# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitmentCandidatesController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  describe '#move' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :move, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'moves candidate to other stage and position' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])

        FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          stage: 'call',
          position: 1
        )

        candidate2 = FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          stage: 'call',
          position: 2
        )

        params = {
          id: candidate2.id,
          candidate: {
            stage: 'interview',
            position: 1
          }
        }

        sign_in admin
        put :move, params: params

        expect(response).to have_http_status 200
        expect(candidate2.reload).to have_attributes(
          position: 1,
          stage: 'interview'
        )
      end

      it 'responds with 422 error if recruitment completed' do
        recruitment = FactoryBot.create(:recruitment, :completed, stages: %w[call interview])

        candidate = FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          stage: 'call',
          position: 1
        )

        params = {
          id: candidate.id,
          candidate: {
            stage: 'interview',
            position: 1
          }
        }

        sign_in admin
        put :move, params: params

        expect(response).to have_http_status 422
      end

      it 'responds with 422 error if invalid stage' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])

        FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          stage: 'call',
          position: 1
        )

        candidate2 = FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          stage: 'call',
          position: 2
        )

        params = {
          id: candidate2.id,
          candidate: {
            stage: 'unknown',
            position: 1
          }
        }

        sign_in admin
        put :move, params: params

        expect(response).to have_http_status 422
        expect(candidate2.reload).to have_attributes(
          position: 2,
          stage: 'call'
        )
      end
    end
  end

  describe '#destroy' do
    context 'when access denied' do
      it 'responds with 401 error' do
        delete :destroy, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'removes recruitment candidate' do
        recruitment = FactoryBot.create(:recruitment, :started)
        candidate = FactoryBot.create(:recruitment_candidate, recruitment: recruitment)

        sign_in admin

        expect do
          delete :destroy, params: { id: candidate.id }
        end.to(change { RecruitmentCandidate.count }.by(-1))

        expect(response).to have_http_status 200
      end

      it 'responds with 403 error when recruitment completed' do
        recruitment = FactoryBot.create(:recruitment, :completed)
        candidate = FactoryBot.create(:recruitment_candidate, recruitment: recruitment)

        sign_in admin

        expect do
          delete :destroy, params: { id: candidate.id }
        end.not_to(change { RecruitmentCandidate.count })

        expect(response).to have_http_status 403
      end

      it 'responds with 404 error if candidate not found' do
        sign_in admin
        delete :destroy, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end
end
