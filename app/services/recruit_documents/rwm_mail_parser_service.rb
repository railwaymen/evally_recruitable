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
        contract_type: contract_type,
        work_type: work_type,
        location: location,
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
      encoded_body.scan(/Name:\s+(.+)\s+Email/i).flatten.first&.strip
    end

    def phone
      encoded_body.scan(/Phone\snumber:\s+(.+)\s+Linkedin/i).flatten.first&.strip
    end

    def email
      encoded_body.scan(/Email:\s(\S+@\S+)\s+Phone/i).flatten.first&.strip
    end

    def position
      encoded_subject.scan(/New\s+candidate\s+for\s+(.+)\s+\|/i).flatten.first&.strip
    end

    def salary
      encoded_body.scan(/Salary:\s+(.+)\s+Contract\s+type/).flatten.first&.strip
    end

    def availability
      encoded_body.scan(/Availability:\s+(.+)\s+job\s+Available/).flatten.first&.strip
    end

    def available_since
      encoded_body.scan(/Available\s+since:\s+(.+)\s+Salary/).flatten.first&.strip
    end

    def contract_type
      encoded_body.scan(/Contract\s+type:\s+(.+)\s+Work\s+type/).flatten.first&.strip
    end

    def work_type
      encoded_body.scan(/Work\s+type:\s+(.+)\s+Location/).flatten.first&.strip
    end

    def location
      encoded_body.scan(/Location:\s+(.+)\s+Accepts\s+current/).flatten.first&.strip
    end

    def message
      # /Message:\s+(.*?)\s+(?=(Attachment|Portfolio|Links))/
      encoded_body.scan(/Message:\s+(.+)\s+Availability/).flatten.first&.strip
    end

    def accept_future_processing
      value = encoded_body.scan(/Accepts\s+future\s+processing:\s+(Yes|No)\s/).flatten.first

      value == 'Yes'
    end

    def raw_body
      encoded_body.scan(/Hi\s+Admin,(.+)\s+Best\s+wishes/).flatten.first&.strip
    end

    def social_links
      return [] if raw_body.blank?

      # URI.extract(raw_body, /http(s)?/).uniq
      raw_body.split(/\s+/).find_all { |word| word =~ /^(http|https|www|ftp)/ }
    end
  end
end
