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
    return senders_map[mail.from.first] if original_sender?

    recipient = mail.recipients.find { |r| MATCHER.match?(r) }
    recipient[MATCHER, 1]
  end

  def original_sender?
    senders_map.keys.include? mail.from.first
  end

  def senders_map
    {
      'info@railwaymen.org' => 'rwm',
      'no-reply@justjoin.it' => 'justjoinit',
      'no-reply@rocketjobs.pl' => 'rocketjobs'
    }
  end
end
