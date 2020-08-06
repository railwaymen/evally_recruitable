# frozen_string_literal: true

class RecruitDocumentsMailbox < ActionMailbox::Base
  GROUP_EMAIL =
    Rails.application.config.env.fetch(:recruitable).fetch(:mailbox).fetch(:group_email)

  EMAIL_MATCHER = Regexp.new(
    Rails.application.config.env.fetch(:recruitable).fetch(:mailbox).fetch(:email_matcher)
  )

  def process
    RecruitDocuments::MailParserService.new(mail, source: source).perform
  end

  private

  def source
    # case for direct mails to GROUP_EMAIL
    return senders_map[mail.from.first] if original_sender?

    # case for forwarded mails
    recipient = mail.recipients.find { |r| EMAIL_MATCHER.match?(r) }
    recipient[EMAIL_MATCHER, 1]
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
