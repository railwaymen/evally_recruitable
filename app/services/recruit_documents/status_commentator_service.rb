# frozen_string_literal: true

module RecruitDocuments
  class StatusCommentatorService
    def initialize(recruit_document, user)
      @recruit_document = recruit_document
      @user = user

      @status ||= RecruitDocuments::StatusesManagerService.find(recruit_document.status)
    end

    def call
      comment_status_change if status_change.save
    end

    private

    def status_change
      @status_change ||= @recruit_document.status_changes.build(
        from: @recruit_document.status_was,
        to: @recruit_document.status,
        details: resolve_details || {}
      )
    end

    def resolve_details
      return if @status.blank?

      @status.required_fields.collect do |field|
        [field.value, @recruit_document.detail(field.value)]
      end.to_h
    end

    def comment_status_change
      resp = core_api_client.post(
        "/v2/recruits/#{@recruit_document.public_recruit_id}/comments/webhook",
        comment: {
          body: status_change.comment_body,
          created_at: status_change.created_at
        }
      )

      Rails.logger.debug(
        "\e[36mStatus Change Sync  |  #{resp.status}  |  id: #{status_change.id}\e[0m"
      )
    end

    def core_api_client
      @core_api_client ||= ApiClientService.new(
        @user, Rails.application.config.env.fetch(:core_host)
      )
    end
  end
end
