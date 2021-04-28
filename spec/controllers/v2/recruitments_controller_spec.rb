# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitmentsController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  describe '#index' do
    context 'when access denied' do
      it 'responds with 401 error' do
        get :index
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'responds with list of recruitments' do
        FactoryBot.create_list(:recruitment, 2)

        sign_in admin
        get :index

        expect(response).to have_http_status 200
        expect(response.body).to have_json_size(2).at_path('recruitments')
      end
    end
  end

  describe '#create' do
    context 'when access denied' do
      it 'responds with 401 error' do
        post :create, params: {}
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'responds with new recruitment' do
        params = {
          recruitment: {
            name: 'RoR Developer'
          }
        }

        sign_in admin
        post :create, params: params

        expect(response).to have_http_status 201
        expect(response.body).to be_json_eql recruitment_schema(Recruitment.last)
      end

      it 'responds with 422 error if params invalid' do
        params = {
          recruitment: {
            name: ''
          }
        }

        sign_in admin

        expect do
          post :create, params: params
        end.not_to(change { Recruitment.count })

        expect(response).to have_http_status 422
      end
    end
  end

  describe '#update' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :update, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'responds with updated recruitment' do
        recruitment = FactoryBot.create(:recruitment, name: 'Old recruitment')

        params = {
          id: recruitment.id,
          recruitment: {
            name: 'New recruitment'
          }
        }

        sign_in admin

        expect do
          put :update, params: params
        end.to(change { recruitment.reload.name }.to('New recruitment'))

        expect(response).to have_http_status 200
        expect(response.body).to be_json_eql recruitment_schema(recruitment)
      end

      it 'responds with 422 error if params invalid' do
        recruitment = FactoryBot.create(:recruitment, name: 'Old recruitment')

        params = {
          id: recruitment.id,
          recruitment: {
            name: ''
          }
        }

        sign_in admin

        expect do
          put :update, params: params
        end.not_to(change { recruitment.reload.name })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        put :update, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#start' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :start, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'starts recruitment and responds with ok' do
        recruitment = FactoryBot.create(:recruitment)

        sign_in admin

        expect do
          put :start, params: { id: recruitment.id }
        end.to(change { recruitment.reload.status }.to('started'))

        expect(response).to have_http_status 200
      end

      it 'responds with 422 error if invalid status' do
        recruitment = FactoryBot.create(:recruitment, :completed)

        sign_in admin

        expect do
          put :start, params: { id: recruitment.id }
        end.not_to(change { recruitment.reload.status })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        put :start, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#complete' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :complete, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'completes recruitment and responds with ok' do
        recruitment = FactoryBot.create(:recruitment, :started)

        sign_in admin

        expect do
          put :complete, params: { id: recruitment.id }
        end.to(change { recruitment.reload.status }.to('completed'))

        expect(response).to have_http_status 200
      end

      it 'responds with 422 error if invalid status' do
        recruitment = FactoryBot.create(:recruitment)

        sign_in admin

        expect do
          put :complete, params: { id: recruitment.id }
        end.not_to(change { recruitment.reload.status })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        put :complete, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#add_stage' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :add_stage, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'adds new stage to recruitment stages' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call])

        sign_in admin

        expect do
          put :add_stage, params: { id: recruitment.id, stage: 'interview' }
        end.to(change { recruitment.reload.stages }.to(%w[call interview]))

        expect(response).to have_http_status 200
      end

      it 'responds with 422 error if invalid stage' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call])

        sign_in admin

        expect do
          put :add_stage, params: { id: recruitment.id, stage: 'call' }
        end.not_to(change { recruitment.reload.status })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        put :add_stage, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end

  describe '#drop_stage' do
    context 'when access denied' do
      it 'responds with 401 error' do
        put :drop_stage, params: { id: 1 }
        expect(response).to have_http_status 401
      end
    end

    context 'when access granted' do
      it 'drops stage from recruitment stages' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])

        sign_in admin

        expect do
          put :drop_stage, params: { id: recruitment.id, stage: 'interview' }
        end.to(change { recruitment.reload.stages }.to(%w[call]))

        expect(response).to have_http_status 200
      end

      it 'responds with 422 error if stage has candidates' do
        recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])
        FactoryBot.create(:recruitment_candidate, recruitment: recruitment, stage: 'interview')

        sign_in admin

        expect do
          put :drop_stage, params: { id: recruitment.id, stage: 'interview' }
        end.not_to(change { recruitment.reload.status })

        expect(response).to have_http_status 422
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        put :drop_stage, params: { id: 1 }

        expect(response).to have_http_status 404
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
      it 'removes recruitment' do
        recruitment = FactoryBot.create(:recruitment)

        sign_in admin

        expect do
          delete :destroy, params: { id: recruitment.id }
        end.to(change { Recruitment.count }.by(-1))

        expect(response).to have_http_status 204
      end

      it 'responds with 404 error if recruitment not found' do
        sign_in admin
        delete :destroy, params: { id: 1 }

        expect(response).to have_http_status 404
      end
    end
  end
end
