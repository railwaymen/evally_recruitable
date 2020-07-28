# frozen_string_literal: true

module RecruitDocuments
  class RocketjobsMailParserService
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
        phone: nil,
        position: position,
        group: 'Unknown',
        source: 'RocketJobs',
        received_at: mail.date,
        accept_current_processing: true,
        accept_future_processing: accept_future_processing,
        social_links: social_links,
        message: message_from_candidate
      )

      return unless recruit_document.save

      Rails.logger.info("\e[44mRocketJobs Parser  |  Done!  |  #{mail.message_id}\e[0m")

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
      encoded_subject.scan(/^Fwd:\s+(.+)\s+aplikuje\s+na/iu).flatten.first&.strip
    end

    def email
      encoded_body.scan(/\*Email\s+kandydata\*:\s+(\S+@\S+)\s/iu).flatten.first&.strip
    end

    def position
      encoded_subject.scan(/aplikuje\s+na\s+(.+)$/iu).flatten.first&.strip
    end

    def message_from_candidate
      encoded_body.scan(/\*Wiadomość\sod\skandydata\*:(.+)Copyright\s©/).flatten.first&.strip
    end

    def accept_future_processing
      value =
        encoded_body
        .scan(/Zgoda\s+na\s+wykorzystanie\s+danych\s+na\s+potrzebę\s+przyszłych\s+rekrutacji\*/iu)
        .flatten
        .first

      value.present?
    end

    def social_links
      URI.extract(message_from_candidate, /http(s)?/).uniq
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
        file << encoded_body
        file.rewind

        recruit_document.files.attach(io: file, filename: filename, content_type: 'text/plain')
      end
    rescue StandardError => e
      Rails.logger.error "\e[31mMail body cannot be saved due to error: #{e.message}\e[0m"
    end
  end
end
