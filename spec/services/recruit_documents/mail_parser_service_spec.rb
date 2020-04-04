# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocuments::MailParserService do
  # Mock external requests
  before(:each) { stub_api_client_service }

  describe 'rwm mails parser' do
    it 'adds new recruit document' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'jobs_rwm@example.com'
        from        'jobs@example.com'
        subject     'Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            Hi,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Accepted future processing data: true

            Message: Lorem ipsum ...
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 2

      expect(recruit_document).to have_attributes(
        first_name: 'Jack',
        last_name: 'Strong',
        email: 'jstrong@example.com',
        phone: '123456789',
        position: 'RoR Developer',
        group: 'Unknown',
        accept_current_processing: true,
        accept_future_processing: true,
        received_at: mail_datetime,
        message_id: 'this_is_test_message_id@example.com'
      )


    end

    it 'raises an error and do not save attachments' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'jobs_rwm@example.com'
        from        'jobs@example.com'
        subject     'Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            Hi,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Accepted future processing data: true

            Message: Lorem ipsum ...
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      allow_any_instance_of(Tempfile).to receive(:rewind).and_raise(StandardError)
      expect(Rails.logger).to receive(:error).twice.and_call_original

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 0
    end
  end

  describe 'unknown mails' do
    it 'skips parsing action' do
      mail = Mail.new do
        to          'jobs_unknown@example.com'
        from        'jobs@example.com'
        subject     'Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        Time.current.round

        text_part do
          body <<~BODY
            Hi,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Accepted future processing data: true

            Message: Lorem ipsum ...
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'unknown')

      expect do
        expect(service.perform).to be_nil
      end.not_to(change { RecruitDocument.count })
    end
  end

  describe 'already parsed mails' do
    it 'skips parsing action' do
      FactoryBot.create(:recruit_document, message_id: 'this_is_test_message_id@example.com')

      mail = Mail.new do
        to          'jobs_rwm@example.com'
        from        'jobs@example.com'
        subject     'Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        Time.current.round

        text_part do
          body <<~BODY
            Hi,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Accepted future processing data: true

            Message: Lorem ipsum ...
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      expect do
        expect(service.perform).to be_nil
      end.not_to(change { RecruitDocument.count })
    end
  end
end
