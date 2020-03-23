# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocumentsController, type: :controller do
  let(:admin) { User.new(id: 1, role: :admin) }

  def stub_webhook_request(user, request_body)
    stub_request(:post, 'http://app.testhost/v2/recruits/webhook')
      .with(
        body: JSON.generate(request_body),
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'Token' => JwtService.encode(user),
          'User-Agent'=>'Faraday v0.17.3'
        }
      )
      .to_return(status: 200, body: '', headers: {})
  end

  describe '#index' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        get :index
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with full list of documents' do
        FactoryBot.create_list(:recruit_document, 2)

        sign_in admin
        get :index

        expect(response).to have_http_status 200
        expect(response.body).to have_json_size(2).at_path('recruit_documents')
      end
    end
  end

  describe '#show' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with document item' do
        document = FactoryBot.create(:recruit_document)

        sign_in admin
        get :show, params: { id: document.id }

        expect(response).to have_http_status 200
        expect(response.body).to be_json_eql recruit_document_schema(document)
      end

      it 'responds with 404 error if document not found' do
        sign_in admin
        get :show, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#form' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        get :form
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with 401 error' do
        FactoryBot.create(:recruit_document)

        sign_in admin
        get :form

        expect(response).to have_http_status 200
        expect(json_response.keys).to contain_exactly('statuses', 'positions', 'groups')
      end
    end
  end

  describe '#create' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        params = { recruit_document: FactoryBot.attributes_for(:recruit_document) }

        post :create, params: params
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with new document' do
        params = { recruit_document: FactoryBot.attributes_for(:recruit_document) }
        public_recruit_id = Digest::SHA256.hexdigest(params.dig(:recruit_document, :email))

        sign_in admin
        stub_webhook_request(admin, recruit: { public_recruit_id: public_recruit_id })

        expect do
          post :create, params: params
        end.to(change { RecruitDocument.count }.by(1))

        expect(response).to have_http_status 201
        expect(response.body).to be_json_eql recruit_document_schema(RecruitDocument.last)
      end

      it 'responds with 422 error if params invalid' do
        params = { recruit_document: FactoryBot.attributes_for(:recruit_document, email: '') }

        sign_in admin
        stub_webhook_request(admin, params)

        expect do
          post :create, params: params
        end.not_to(change { RecruitDocument.count })

        expect(response).to have_http_status 422
      end
    end
  end

  describe '#update' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        document = FactoryBot.create(:recruit_document)

        params = {
          id: document.id,
          recruit_document: {
            first_name: 'Szczepan'
          }
        }

        put :update, params: params
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with updated document' do
        document = FactoryBot.create(:recruit_document)

        params = {
          id: document.id,
          recruit_document: {
            first_name: 'Szczepan'
          }
        }

        sign_in admin
        stub_webhook_request(admin, recruit: { public_recruit_id: document.public_recruit_id })

        expect do
          put :update, params: params
          document.reload
        end.to(change { document.first_name }.to('Szczepan'))

        expect(response).to have_http_status 200
        expect(response.body).to be_json_eql recruit_document_schema(document)
      end

      it 'responds with 422 error if invalid params' do
        document = FactoryBot.create(:recruit_document)

        params = {
          id: document.id,
          recruit_document: {
            first_name: ''
          }
        }

        sign_in admin

        expect do
          put :update, params: params
        end.not_to(change { document.first_name })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if document not found' do
        params = {
          id: 1,
          recruit_document: {
            first_name: 'Szczepan'
          }
        }

        sign_in admin
        put :update, params: params

        expect(response).to have_http_status 404
      end
    end
  end
end
