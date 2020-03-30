# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocumentPolicy, type: :policy do
  describe 'scope' do
    it 'returns correct scope' do
      admin = User.new(id: 1, role: 'admin')
      recruiter = User.new(id: 2, role: 'recruiter')
      evaluator = User.new(id: 3, role: 'evaluator')

      document1 = FactoryBot.create(:recruit_document)
      document2 = FactoryBot.create(:recruit_document, evaluator_id: evaluator.id)

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
