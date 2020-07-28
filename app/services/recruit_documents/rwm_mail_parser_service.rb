# frozen_string_literal: true

module RecruitDocuments
  class RwmMailParserService
    delegate :mail, :source, :recruit_document, to: :@context

    def initialize(context)
      @context = context
    end

    def perform # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
        accept_future_processing: accept_future_processing,
        social_links: social_links,
        salary: salary,
        availability: availability,
        available_since: available_since,
        message: message
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

    def encoded_body
      @encoded_body ||= plain_text.body.to_s.force_encoding(Encoding::UTF_8).gsub(/(\r|\n)/, ' ')
    end

    def encoded_subject
      @encoded_subject ||= mail.subject.to_s.force_encoding(Encoding::UTF_8)
    end

    def fullname
      encoded_body.scan(/Name:\s+(.+)\s/i).flatten.first&.strip
    end

    def phone
      encoded_body.scan(/Phone\snumber:\s+(.+)\s+Linkedin/).flatten.first&.strip
    end

    def email
      encoded_body.scan(/Email:\s(\S+@\S+)\s/i).flatten.first&.strip
    end

    def position
      encoded_subject.scan(/New applicant for\s+(.+)\./i).flatten.first&.strip
    end

    def salary; end

    def availability; end

    def available_since; end

    def message; end

    def accept_future_processing
      value = encoded_body.scan(/future processing data:\s+(true|false)\s/).flatten.first

      value == 'true'
    end

    def raw_body
      encoded_body.scan(/Hi\sAdmin,(.+)Railwaymen\sDev\sTeam/).flatten.first&.strip
    end

    def social_links
      URI.extract(raw_body, /http(s)?/).uniq
    end

    def save_attachment(attachment)
      Tempfile.open(attachment.filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << attachment.decoded
        file.rewind

        recruit_document.files.attach(io: file, filename: attachment.filename)
      end
    rescue StandardError => e
      Rails.logger.error "\e[31mFile cannot be attached due to error: #{e.message}\e[0m"
    end

    def save_mail_body
      filename = 'message.txt'

      Tempfile.open(filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << plain_text.body.to_s
        file.rewind

        recruit_document.files.attach(io: file, filename: filename, content_type: 'text/plain')
      end
    rescue StandardError => e
      Rails.logger.error "\e[31mMail body cannot be saved due to error: #{e.message}\e[0m"
    end
  end
end
