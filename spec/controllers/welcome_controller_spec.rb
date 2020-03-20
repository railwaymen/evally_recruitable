# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'unauthorized access' do
    it 'responds with 401 error' do
      get :index

      expect(response).to have_http_status 401
    end
  end

  describe 'authorized access' do
    it 'response with status 200' do
      sign_in

      get :index

      expect(response).to have_http_status 200
      expect(json_response['message']).to eq 'Hello Evally Recruitable!'
    end
  end
end
