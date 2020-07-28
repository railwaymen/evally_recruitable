# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::InboundEmailsController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  describe '#index' do
    context 'when access denied' do
      it 'responds with 401 error' do
        get :index
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'responds with 200' do
        receive_inbound_email_from_mail(
          from: 'website@example.com',
          to: 'evallyrecruitable+source@example.com',
          subject: 'Sample Subject',
          body: 'Lorem ipsum'
        )

        sign_in admin
        get :index, params: { sort_by: 'status', sort_dir: 'desc' }

        expect(response).to have_http_status 200
        expect(json_response['inbound_emails'].length).to eq 1
      end
    end
  end
end
