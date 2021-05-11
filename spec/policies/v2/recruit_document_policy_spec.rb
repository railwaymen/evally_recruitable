# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocumentPolicy, type: :policy do
  describe 'scope' do
    it 'returns correct scope' do
      admin = FactoryBot.create(:user, role: :admin)
      recruiter = FactoryBot.create(:user, role: :recruiter)
      evaluator = FactoryBot.create(:user, role: :evaluator)

      recruitment = FactoryBot.create(:recruitment, :started)

      document1 = FactoryBot.create(:recruit_document)
      document2 = FactoryBot.create(:recruit_document)

      FactoryBot.create(
        :recruitment_participant,
        recruitment: recruitment,
        user: evaluator
      )

      FactoryBot.create(
        :recruitment_candidate,
        recruitment: recruitment,
        recruit_document: document2
      )

      aggregate_failures 'for admin' do
        scope = Pundit.policy_scope!(admin, [:v2, RecruitDocument])

        expect(scope.ids).to contain_exactly(document1.id, document2.id)
      end

      aggregate_failures 'for recruiter' do
        scope = Pundit.policy_scope!(recruiter, [:v2, RecruitDocument])

        expect(scope.ids).to contain_exactly(document1.id, document2.id)
      end

      aggregate_failures 'for evaluator' do
        scope = Pundit.policy_scope!(evaluator, [:v2, RecruitDocument])

        expect(scope.ids).to contain_exactly(document2.id)
      end
    end
  end
end
