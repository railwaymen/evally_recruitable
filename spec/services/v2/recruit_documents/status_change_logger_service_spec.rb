# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::StatusChangeLoggerService do
  before(:each) { ActionMailer::Base.deliveries.clear }

  describe '.call' do
    it 'expects to log status change on status update' do
      current_user = FactoryBot.create(:user)

      document = FactoryBot.create(:recruit_document, status: 'received')
      document.status = 'verified'

      service = described_class.new(document, current_user)

      expect do
        expect(service.call).to eq true
      end.to(change { document.status_changes.count }.by(1))

      expect(document.status_changes.last).to have_attributes(
        from: 'received',
        to: 'verified',
        details: {}
      )
    end

    it 'expects to log status change on status details udpate' do
      current_user = FactoryBot.create(:user)

      document = FactoryBot.create(
        :recruit_document,
        status: 'rejected',
        rejection_reason: 'Hello World!'
      )
      document.rejection_reason = 'Lorem ipsum...'

      service = described_class.new(document, current_user)

      expect do
        expect(service.call).to eq true
      end.to(change { document.status_changes.count }.by(1))

      expect(document.status_changes.last).to have_attributes(
        from: 'rejected',
        to: 'rejected',
        details: {
          rejection_reason: 'Lorem ipsum...'
        }
      )
    end
  end

  describe '.notify' do
    it 'expects to notify other recruiter about status change' do
      current_user = FactoryBot.create(:user)
      recruiter = FactoryBot.create(:user, role: :recruiter)

      document = FactoryBot.create(:recruit_document, status: 'code_review')
      document.assign_attributes(
        status: 'recruitment_task',
        task_sent_at: Time.current
      )

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.to(change { ActionMailer::Base.deliveries.size }.by(1))

      expect(ActionMailer::Base.deliveries.last.to).to contain_exactly recruiter.email
    end

    it 'expects to dismiss notification if status not changed' do
      current_user = FactoryBot.create(:user)
      FactoryBot.create(:user, role: :recruiter)

      document = FactoryBot.create(:recruit_document, status: 'code_review')

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.not_to(change { ActionMailer::Base.deliveries.size })
    end

    it 'expects to dismiss notification if status without notifiees' do
      current_user = FactoryBot.create(:user)
      FactoryBot.create(:user, role: :recruiter)

      document = FactoryBot.create(:recruit_document, status: 'received')
      document.status = 'documents_review'

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.not_to(change { ActionMailer::Base.deliveries.size })
    end

    it 'expects to notify admin as allowed status notifiee' do
      current_user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, role: :admin)

      document = FactoryBot.create(:recruit_document, status: 'code_review', evaluator: admin)
      document.assign_attributes(
        status: 'phone_call',
        call_scheduled_at: Time.current
      )

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.to(change { ActionMailer::Base.deliveries.size }.by(1))

      expect(ActionMailer::Base.deliveries.last.to).to contain_exactly admin.email
    end

    it 'expects to notify recruiter as allowed status notifiee' do
      current_user = FactoryBot.create(:user)
      recruiter = FactoryBot.create(:user, role: :recruiter)

      document = FactoryBot.create(:recruit_document, status: 'code_review', evaluator: recruiter)
      document.assign_attributes(
        status: 'phone_call',
        call_scheduled_at: Time.current
      )

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.to(change { ActionMailer::Base.deliveries.size }.by(1))

      expect(ActionMailer::Base.deliveries.last.to).to contain_exactly recruiter.email
    end

    it 'expects to notify evaluator as allowed status notifiee' do
      current_user = FactoryBot.create(:user)
      evaluator = FactoryBot.create(:user, role: :evaluator)

      document = FactoryBot.create(:recruit_document, status: 'code_review', evaluator: evaluator)
      document.assign_attributes(
        status: 'phone_call',
        call_scheduled_at: Time.current
      )

      service = described_class.new(document, current_user)

      expect do
        perform_enqueued_jobs do
          service.call
          service.notify
        end
      end.to(change { ActionMailer::Base.deliveries.size }.by(1))

      expect(ActionMailer::Base.deliveries.last.to).to contain_exactly evaluator.email
    end
  end
end
