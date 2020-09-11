# frozen_string_literal: true

module RecruitDocuments
  class RwmMailParserService
    delegate :mail, :source, to: :@context

    def initialize(context)
      @context = context
    end

    def parse # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      first_name, last_name = fullname.split(' ')

      {
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
      encoded_body.scan(/Name:\s+(.+)\s/i).flatten.first&.strip
    end

    def phone
      encoded_body.scan(/Phone\snumber:\s+(.+)\s+Linkedin/).flatten.first&.strip
    end

    def email
      encoded_body.scan(/Email:\s(\S+@\S+)\s/i).flatten.first&.strip
    end

    def position
      encoded_subject.scan(/New\s+applicant\s+for\s+(.+)\./i).flatten.first&.strip
    end

    def salary
      encoded_body.scan(/Salary:\s+(.+)\s+Working/).flatten.first&.strip
    end

    def availability
      encoded_body.scan(/Working\s+hours:\s+(.+)\s+Start/).flatten.first&.strip
    end

    def available_since; end

    def message
      encoded_body.scan(/Message:\s+(.*?)\s+(?=(Attachment|Portfolio|Links))/).flatten.first&.strip
    end

    def accept_future_processing
      value = encoded_body.scan(/future\s+processing\s+data:\s+(true|false)\s/).flatten.first

      value == 'true'
    end

    def raw_body
      encoded_body.scan(/Hi\s+Admin,(.+)Railwaymen\s+Dev\s+Team/).flatten.first&.strip
    end

    def social_links
      return [] if raw_body.blank?

      URI.extract(raw_body, /http(s)?/).uniq
    end
  end
end
