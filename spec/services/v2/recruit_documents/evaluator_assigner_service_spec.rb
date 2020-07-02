# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::EvaluatorAssignerService do
  describe '.call' do
    it 'expects to assign evaluator to all previous documents' do
      user = FactoryBot.create(:user)

      document1, document2 = FactoryBot.create_list(:recruit_document, 2, email: 'jack@example.com')
      document1.evaluator_token = user.email_token

      service = described_class.new(document1, user)

      expect do
        service.call
      end.to(change { document2.reload.evaluator_token }.to(user.email_token))
    end
  end

  describe '.notify' do
    it 'expects to notify involved users about new assignment' do
      user = FactoryBot.create(:user)
      recruiter = FactoryBot.create(:user, role: :recruiter)

      document = FactoryBot.create(:recruit_document, email: 'jack@example.com', evaluator: nil)
      document.evaluator_token = user.email_token

      service = described_class.new(document, user)

      expect do
        perform_enqueued_jobs do
          service.call && document.save

          service.notify
        end
      end.to(change { ActionMailer::Base.deliveries.size }.by(2))

      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to contain_exactly(
        user.email, recruiter.email
      )
    end
  end
end
