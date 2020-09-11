# frozen_string_literal: true

module RecruitDocuments
  class RocketjobsMailParserService
    delegate :mail, :source, to: :@context

    def initialize(context)
      @context = context
    end

    def parse # rubocop:disable Metrics/MethodLength
      first_name, last_name = fullname.split(' ')

      {
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
      }
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
      encoded_body.scan(/\*Wiadomość\s+od\s+kandydata\*:(.+)Copyright\s+©/).flatten.first&.strip
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
      return [] if message_from_candidate.blank?

      URI.extract(message_from_candidate, /http(s)?/).uniq
    end
  end
end
