# frozen_string_literal: true

module RecruitDocuments
  class MailParserService
    attr_reader :mail, :source, :recruit_document

    def initialize(mail, source:)
      @mail = mail
      @source = source.to_s.downcase

      @user = User.admin.first

      @recruit_document = RecruitDocument.find_or_initialize_by(
        message_id: mail.message_id,
        received_at: mail.date
      )
    end

    def perform
      return unless accepted_source? && @recruit_document.new_record?

      V2::Sync::RecruitSyncService.new(parser.recruit_document, @user).perform if parser.perform
    end

    private

    def accepted_source?
      %w[rwm justjoinit rocketjobs].include? @source
    end

    def parser_class_name
      "RecruitDocuments::#{@source.to_s.capitalize}MailParserService"
    end

    def parser
      @parser ||= parser_class_name.constantize.new(self)
    end
  end
end
