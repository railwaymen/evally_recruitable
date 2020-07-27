# frozen_string_literal: true

class RecruitDocumentsMailbox < ActionMailbox::Base
  MATCHER = Regexp.new(
    Rails
      .application
      .config
      .env
      .fetch(:recruitable)
      .fetch(:mailboxes)
      .fetch(:recruit_documents_matcher)
  )

  def process
    RecruitDocuments::MailParserService.new(mail, source: source).perform
  end

  private

  def source
    recipient = mail.recipients.find { |r| MATCHER.match?(r) }

    recipient[MATCHER, 1]
  end
end
