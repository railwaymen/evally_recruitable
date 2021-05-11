# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::PoliciesController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: :admin) }
  let(:evaluator) { FactoryBot.create(:user, role: :evaluator) }

  describe '#recruit' do
    context 'access granted' do
      it 'for admin' do
        document = FactoryBot.create(:recruit_document)

        sign_in admin
        get :recruit, params: { public_recruit_id: document.public_recruit_id }

        expect(response).to have_http_status 204
      end

      it 'for evaluator as recruitment participant' do
        recruitment = FactoryBot.create(:recruitment, :started, stages: %w[call interview])
        document = FactoryBot.create(:recruit_document)

        FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          recruit_document: document,
          stage: 'call'
        )

        FactoryBot.create(
          :recruitment_participant,
          recruitment: recruitment,
          user: evaluator
        )

        sign_in evaluator
        get :recruit, params: { public_recruit_id: document.public_recruit_id }

        expect(response).to have_http_status 204
      end
    end

    context 'access denied' do
      it 'for common evaluator' do
        recruitment = FactoryBot.create(:recruitment, :started, stages: %w[call interview])
        document = FactoryBot.create(:recruit_document)

        FactoryBot.create(
          :recruitment_candidate,
          recruitment: recruitment,
          recruit_document: document,
          stage: 'call'
        )

        sign_in evaluator
        get :recruit, params: { public_recruit_id: document.public_recruit_id }

        expect(response).to have_http_status 403
      end
    end
  end
end
