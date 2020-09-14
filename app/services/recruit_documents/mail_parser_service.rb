# frozen_string_literal: true

module RecruitDocuments
  class MailParserService
    attr_reader :mail, :source, :recruit_document

    delegate :parse, to: :parser

    def initialize(mail, source:)
      @mail = mail
      @source = source.to_s.downcase

      @user = User.admin.first

      @recruit_document = RecruitDocument.find_or_initialize_by(
        message_id: mail.message_id,
        received_at: mail.date
      )
    end

    def perform # rubocop:disable Metrics/AbcSize
      return unless accepted_source? && @recruit_document.new_record?

      @recruit_document.assign_attributes(parser.parse)

      return unless @recruit_document.save

      V2::Sync::RecruitSyncService.new(@recruit_document, @user).perform
      Rails.logger.info("\e[44m#{@source}Parser  |  Done!  |  #{mail.message_id}\e[0m")

      save_mail_body
      @mail.attachments.each(&method(:save_attachment))
    end

    private

    def accepted_source?
      %w[rwm justjoinit rocketjobs nofluffjobs].include? @source
    end

    def parser_class_name
      "RecruitDocuments::#{@source.to_s.capitalize}MailParserService"
    end

    def parser
      @parser ||= parser_class_name.constantize.new(self)
    end

    def save_mail_body
      filename = 'message.txt'

      Tempfile.open(filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << @mail.find_first_mime_type('text/plain')&.body.to_s
        file.rewind

        @recruit_document.files.attach(io: file, filename: filename, content_type: 'text/plain')
      end
    rescue StandardError => e
      Rails.logger.error "\e[31mMail body cannot be saved due to error: #{e.message}\e[0m"
    end

    def save_attachment(attachment)
      Tempfile.open(attachment.filename, '/tmp', encoding: 'ascii-8bit') do |file|
        file << attachment.decoded
        file.rewind

        @recruit_document.files.attach(io: file, filename: attachment.filename)
      end
    rescue StandardError => e
      Rails.logger.error "\e[31mFile cannot be attached due to error: #{e.message}\e[0m"
    end
  end
end
