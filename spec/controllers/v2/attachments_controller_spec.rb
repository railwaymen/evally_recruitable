# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::AttachmentsController, type: :controller do
  let(:admin) { User.new(id: 1, role: :admin) }

  describe '#create' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        post :create, params: { recruit_document_id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'responds with newest file' do
        document = FactoryBot.create(:recruit_document, :with_attachment)

        file = fixture_file_upload(
          Rails.root.join('spec/fixtures/sample_image.jpg'),
          'image/jpeg'
        )

        params = {
          recruit_document_id: document.id,
          files: [file]
        }

        sign_in admin
        allow_any_instance_of(ActiveStorage::Blob).to receive(:service_url).and_return ''

        expect do
          post :create, params: params
        end.to(change { document.files.attachments.count }.by(1))

        expect(response).to have_http_status 201
        expect(response.body).to have_json_size(2)
      end

      it 'responds with 404 error if recruit document not found' do
        file = fixture_file_upload(
          Rails.root.join('spec/fixtures/sample_resume.pdf'),
          'application/pdf'
        )

        params = {
          recruit_document_id: 1,
          files: [file]
        }

        sign_in admin
        post :create, params: params

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#destroy' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        delete :destroy, params: { recruit_document_id: 1, id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when authorized' do
      it 'removes file and responds with 204' do
        document = FactoryBot.create(:recruit_document, :with_attachment)
        file = document.files.last

        sign_in admin

        expect do
          delete :destroy, params: { recruit_document_id: document.id, id: file.id }
        end.to(change { document.files.count }.by(-1))

        expect(response).to have_http_status 204
      end

      it 'responds with 404 if file not found' do
        document = FactoryBot.create(:recruit_document)

        sign_in admin
        delete :destroy, params: { recruit_document_id: document.id, id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end
end
