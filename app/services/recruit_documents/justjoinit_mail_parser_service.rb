# frozen_string_literal: true

module RecruitDocuments
  class JustjoinitMailParserService
    delegate :mail, :source, to: :@context

    def initialize(context)
      @context = context
    end

    def parse # rubocop:disable Metrics/MethodLength
      first_name, last_name = fullname.split(' ')

      {
        first_name: first_name.to_s.strip,
        last_name: last_name.to_s.strip,
        email: email,
        phone: nil,
        position: position,
        group: 'Unknown',
        source: 'JustJoinIT',
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

    def fullname
      encoded_body.scan(/\*(.+)\*\s+is\s+applying\s+for/i).flatten.first&.strip
    end

    def email
      encoded_body.scan(/\*Candidate\s+email\*:\s+(\S+@\S+)\s/i).flatten.first&.strip
    end

    def position
      encoded_body.scan(/is\s+applying\s+for\s+\*(.+)\s+<http.*>/i).flatten.first&.strip
    end

    def message_from_candidate
      encoded_body.scan(/\*Message\s+from\s+candidate\*:(.+)Copyright\s+©/).flatten.first&.strip
    end

    def accept_future_processing
      value = encoded_body.scan(/\*.+Processing data in future recruitment\*/).flatten.first

      value.present?
    end

    def social_links
      return [] if message_from_candidate.blank?

      URI.extract(message_from_candidate, /http(s)?/).uniq
    end
  end
end
