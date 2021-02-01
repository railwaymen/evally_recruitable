# frozen_string_literal: true

module RecruitDocuments
  class NofluffjobsMailParserService
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
        source: 'NoFluffJobs',
        received_at: mail.date,
        accept_current_processing: true,
        accept_future_processing: accept_future_processing,
        social_links: social_links,
        message: message_from_candidate
      }
    end

    private

    def html_part
      @html_part ||= mail.find_first_mime_type('text/html')
    end

    def plain_text
      @plain_text ||= Nokogiri::HTML.parse(html_part.body.to_s).text.squish
    end

    def fullname
      plain_text.scan(/Name:\s+(.+)E-mail/).flatten.first&.strip
    end

    def email
      plain_text.scan(/E-mail:\s+(.+)Linkedin/).flatten.first&.strip
    end

    def position
      plain_text.scan(/Applied\s+for:\s+(.+)View/).flatten.first&.strip
    end

    def message_from_candidate
      plain_text.scan(/Message:\s+(.+)Consent/).flatten.first&.strip
    end

    def accept_future_processing
      value =
        plain_text
        .scan(/Processing\s+data\s+in\s+future\s+recruitment\s+processes:\s+(.+)Pro/)
        .flatten
        .first
        &.strip

      value == 'Yes'
    end

    def social_links
      return [] if plain_text.blank?

      URI.extract(plain_text, /http(s)?/).uniq
    end
  end
end
