# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocumentsController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }
  let(:evaluator) { FactoryBot.create(:user, role: :evaluator) }

  describe '#index' do
    context 'when access denied' do
      it 'responds with 401 error' do
        get :index
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
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
    context 'when access denied' do
      it 'responds with 401 error' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'responds with document item' do
        document = FactoryBot.create(:recruit_document)

        sign_in admin
        get :show, params: { id: document.id }

        expect(response).to have_http_status 200
        expect(json_response.keys).to contain_exactly(
          'recruit_document', 'attachments', 'positions', 'statuses', 'groups', 'sources'
        )
      end

      it 'responds with 404 error if document not found' do
        sign_in admin
        get :show, params: { id: 1 }

        expect(response).to have_http_status 404
      end

      it 'responds with 404 error if foreign document' do
        document = FactoryBot.create(:recruit_document)

        sign_in evaluator
        get :show, params: { id: document.id }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#form' do
    context 'when access denied' do
      it 'responds with 401 error' do
        get :form
        expect(response).to have_http_status 401
      end

      it 'responds with 403 error' do
        sign_in evaluator
        get :form

        expect(response).to have_http_status 403
      end
    end

    context 'when access granted' do
      it 'responds with form data' do
        FactoryBot.create(:recruit_document)

        sign_in admin
        get :form

        expect(response).to have_http_status 200
        expect(json_response.keys).to contain_exactly(
          'recruit_document', 'attachments', 'positions', 'statuses', 'groups', 'sources'
        )
      end
    end
  end

  describe '#create' do
    context 'when access denied' do
      it 'responds with 401 error' do
        post :create, params: {}
        expect(response).to have_http_status 401
      end

      it 'responds with 403 error' do
        params = {
          recruit_document: {
            **FactoryBot.attributes_for(:recruit_document),
            email: 'random@example.com',
            evaluator_id: 1,
            status: { value: 'received' }
          }
        }

        sign_in evaluator
        post :create, params: params

        expect(response).to have_http_status 403
      end
    end

    context 'when access granted' do
      it 'responds with new document' do
        params = {
          recruit_document: {
            **FactoryBot.attributes_for(:recruit_document),
            email: 'random@example.com',
            evaluator_id: 1,
            status: { value: 'received' },
            social_links: 'http://github.com/railwaymen,https://linkedin.com/in/railwaymen'
          }
        }

        sign_in admin

        expect do
          stub_api_client_service
          post :create, params: params
        end.to(change { RecruitDocument.count }.by(1))

        expect(response).to have_http_status 201
        expect(response.body).to be_json_eql recruit_document_schema(RecruitDocument.last)
      end

      it 'responds with 422 error if params invalid' do
        params = {
          recruit_document: {
            **FactoryBot.attributes_for(:recruit_document),
            email: '',
            status: { value: 'received' }
          }
        }

        sign_in admin

        expect do
          post :create, params: params
        end.not_to(change { RecruitDocument.count })

        expect(response).to have_http_status 422
      end

      it 'expects to upload file' do
        file = fixture_file_upload(
          Rails.root.join('spec/fixtures/sample_resume.pdf'),
          'application/pdf'
        )

        params = {
          recruit_document: {
            **FactoryBot.attributes_for(:recruit_document),
            email: 'random@example.com',
            status: { value: 'received' },
            files: [file]
          }
        }

        sign_in admin

        allow_any_instance_of(ActiveStorage::Blob).to receive(:service_url).and_return ''

        expect do
          stub_api_client_service
          post :create, params: params
        end.to(change { ActiveStorage::Attachment.count }.by(1))

        expect(response).to have_http_status 201
        expect(response.body).to be_json_eql recruit_document_schema(RecruitDocument.last)
      end
    end
  end

  describe '#update' do
    context 'when access denied' do
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

    context 'when access granted' do
      it 'responds with updated document' do
        document = FactoryBot.create(:recruit_document, evaluator_id: admin.id)

        params = {
          id: document.id,
          recruit_document: {
            first_name: 'Szczepan'
          }
        }

        sign_in admin

        expect do
          stub_api_client_service
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

    context 'status change' do
      it 'creates status change record' do
        document = FactoryBot.create(:recruit_document, status: 'verified')

        params = {
          id: document.id,
          recruit_document: {
            call_scheduled_at: 3.days.from_now,
            status: { value: 'phone_call' }
          }
        }

        sign_in admin

        expect do
          stub_api_client_service
          put :update, params: params
        end.to(change { document.status_changes.count }.by(1))

        expect(response).to have_http_status 200
      end

      it 'perform background job for synchronization' do
        document = FactoryBot.create(:recruit_document, status: 'verified')

        params = {
          id: document.id,
          recruit_document: {
            call_scheduled_at: 3.days.from_now,
            status: { value: 'phone_call' }
          }
        }

        sign_in admin

        expect do
          stub_api_client_service
          put :update, params: params
        end.to(have_enqueued_job(V2::Sync::StatusChangesJob))
      end
    end
  end

  describe '#destroy' do
    context 'when access denied' do
      it 'responds with 401 error' do
        delete :destroy, params: { id: 1 }
        expect(response).to have_http_status 401
      end

      it 'responds with 403 error' do
        document = FactoryBot.create(:recruit_document)

        sign_in evaluator
        delete :destroy, params: { id: document.id }

        expect(response).to have_http_status 403
      end
    end

    context 'when access granted' do
      it 'removes recruit document' do
        document = FactoryBot.create(:recruit_document)

        sign_in admin

        expect do
          delete :destroy, params: { id: document.id }
        end.to(change { RecruitDocument.count }.by(-1))

        expect(response).to have_http_status 204
      end

      it 'removes attachment too' do
        document = FactoryBot.create(:recruit_document, :with_attachment)

        sign_in admin

        expect do
          delete :destroy, params: { id: document.id }
        end.to(change { ActiveStorage::Attachment.count }.by(-1))

        expect(response).to have_http_status 204
      end

      it 'responds with 404 error if recruit document not found' do
        sign_in admin
        delete :destroy, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end
end
