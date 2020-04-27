# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  describe 'when unauthorized' do
    it 'responds with 401 error' do
      get :index

      expect(response).to have_http_status 401
    end
  end

  describe 'when authorized' do
    it 'response with status 200' do
      sign_in admin

      get :index

      expect(response).to have_http_status 200
      expect(json_response['message']).to eq 'Hello Evally Recruitable!'
    end

    it 'expects current user to be present' do
      sign_in admin

      get :index

      expect(subject.send(:current_user)).to be_admin
    end
  end
end
