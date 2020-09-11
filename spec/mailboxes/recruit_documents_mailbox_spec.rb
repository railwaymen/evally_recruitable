# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocumentsMailbox, type: :mailbox do
  describe 'proper parsers calling' do
    it 'expects to call rwm mail parser service base on suffix' do
      expect_any_instance_of(RecruitDocuments::RwmMailParserService)
        .to(receive(:perform).and_return(source: 'rwm'))

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+rwm@example.com'
      )
    end

    it 'expects to call rwm mail parser service based on from attribute' do
      expect_any_instance_of(RecruitDocuments::RwmMailParserService)
        .to(receive(:perform).and_return(source: 'rwm'))

      receive_inbound_email_from_mail(
        from: 'info@railwaymen.org',
        to: 'evallyrecruitable@example.com'
      )
    end

    it 'expects to call justjoinit mail parser service based on suffix' do
      expect_any_instance_of(RecruitDocuments::JustjoinitMailParserService)
        .to(receive(:perform).and_return(source: 'justjoinit'))

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+justjoinit@example.com'
      )
    end

    it 'expects to call justjoinit mail parser service based on from attribute' do
      expect_any_instance_of(RecruitDocuments::JustjoinitMailParserService)
        .to(receive(:perform).and_return(source: 'justjoinit'))

      receive_inbound_email_from_mail(
        from: 'no-reply@justjoin.it',
        to: 'evallyrecruitable@example.com'
      )
    end

    it 'expects to call rocketjobs mail parser service base on suffix' do
      expect_any_instance_of(RecruitDocuments::RocketjobsMailParserService)
        .to(receive(:perform).and_return(source: 'rocketjobs'))

      receive_inbound_email_from_mail(
        from: 'jobs@example.com',
        to: 'evallyrecruitable+rocketjobs@example.com'
      )
    end

    it 'expects to call rocketjobs mail parser service base on from attribute' do
      expect_any_instance_of(RecruitDocuments::RocketjobsMailParserService)
        .to(receive(:perform).and_return(source: 'rocketjobs'))

      receive_inbound_email_from_mail(
        from: 'no-reply@rocketjobs.pl',
        to: 'evallyrecruitable@example.com'
      )
    end
  end
end
