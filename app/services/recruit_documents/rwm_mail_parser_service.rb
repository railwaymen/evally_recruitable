# frozen_string_literal: true

module RecruitDocuments
  class RwmMailParserService
    delegate :mail, :source, :recruit_document, to: :@context

    def initialize(context)
      @context = context
    end

    def perform
      return unless recruit_document.received_status?

      first_name, last_name = fullname.split(' ')

      recruit_document.assign_attributes(
        first_name: first_name&.strip,
        last_name: last_name&.strip,
        email: email,
        phone: phone,
        position: position,
        group: 'Unknown',
        source: 'RWM Website',
        received_at: mail.date,
        accept_current_processing: true,
        accept_future_processing: accept_future_processing
      )

      return unless recruit_document.save

      Rails.logger.info("\e[44mRWM Parser  |  Done!  |  #{mail.message_id}\e[0m")

      save_mail_body
      mail.attachments.each(&method(:save_attachment))
    end

    private

    def plain_text
      @plain_text ||= mail.find_first_mime_type('text/plain')
    end

    def fullname
      plain_text.body.to_s.scan(/Name:\s+(.+)\s/i).flatten.first&.strip
    end

    def phone
      plain_text.body.to_s.scan(/Phone number:\s+(.+)\s/i).flatten.first&.strip
    end

    def email
      plain_text.body.to_s.scan(/Email:\s+(.+@.+)\s/i).flatten.first&.strip
    end

    def position
      # plain_text.body.to_s.scan(/Position:\s+(.+)\s/i).flatten.first&.strip

      mail.subject.to_s.scan(/New applicant for\s+(.+)\./i).flatten.first&.strip
    end

    def accept_future_processing
      value = plain_text.body.to_s.scan(/future processing data:\s+(true|false)\s/).flatten.first

      value == 'true'
    end

    def save_attachment(attachment)
      Tempfile.open(attachment.filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << attachment.decoded
        file.rewind

        recruit_document.files.attach(io: file, filename: attachment.filename)
      end
    rescue => e
      Rails.logger.error "\e[31mFile cannot be attached due to error: #{e.message}\e[0m"
    end

    def save_mail_body
      filename = 'message.txt'

      Tempfile.open(filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << plain_text.body.to_s
        file.rewind

        recruit_document.files.attach(io: file, filename: filename, content_type: 'text/plain')
      end
    rescue => e
      Rails.logger.error "\e[31mMail body cannot be saved due to error: #{e.message}\e[0m"
    end
  end
end
