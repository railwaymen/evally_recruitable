# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocumentsMailbox, type: :mailbox do
  describe 'proper parsers calling' do
    it 'expects to call rwm mail parser service' do
      expect_any_instance_of(RecruitDocuments::RwmMailParserService).to receive(:perform)

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+rwm@example.com'
      )
    end

    it 'expects to call justjoinit mail parser service' do
      expect_any_instance_of(RecruitDocuments::JustjoinitMailParserService).to receive(:perform)

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+justjoinit@example.com'
      )
    end

    it 'expects to call rocketjobs mail parser service' do
      expect_any_instance_of(RecruitDocuments::RocketjobsMailParserService).to receive(:perform)

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+rocketjobs@example.com'
      )
    end
  end
end
