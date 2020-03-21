require 'rails_helper'

RSpec.describe V2::RecruitDocumentsController, type: :controller do
  let(:admin) { User.new(id: 1, role: :admin) }

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
        expect(response.body).to have_json_size 2
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

  xdescribe '#form' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        get :form
        expect(response).to have_http_status 401
      end
    end
  end

  xdescribe '#create' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        params = { recruit_document: FactoryBot.attributes_for(:recruit_document) }

        post :create, params: params
        expect(response).to have_http_status 401
      end
    end
  end

  xdescribe '#update' do
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
  end

  xdescribe '#destroy' do
    context 'when unauthorized' do
      it 'responds with 401 error' do
        delete :destroy, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end
  end
end
