# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::UsersController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  describe '#webhook' do
    context 'when access denied' do
      it 'responds with 401 error' do
        post :webhook, params: { user: {} }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'creates user and responds 204' do
        params = {
          user: {
            id: admin.id + 1,
            email: 'jparker@example.com',
            first_name: 'Jack',
            last_name: 'Parker',
            role: 'evaluator',
            status: 'active'
          }
        }

        sign_in admin

        expect do
          post :webhook, params: params
        end.to(change { User.count }.by(1))

        expect(response).to have_http_status 204
      end

      it 'updates user and responds 204' do
        user = FactoryBot.create(:user, role: :evaluator)

        params = {
          user: {
            email: user.email,
            role: 'recruiter'
          }
        }

        sign_in admin

        expect do
          post :webhook, params: params
        end.to(change { user.reload.role }.from('evaluator').to('recruiter'))

        expect(response).to have_http_status 204
      end

      it 'responds 422 when user invalid' do
        user = FactoryBot.create(:user, role: :evaluator)

        params = {
          user: {
            email: user.email,
            role: ''
          }
        }

        sign_in admin
        post :webhook, params: params

        expect(response).to have_http_status 422
      end
    end
  end
end
