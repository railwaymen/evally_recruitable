# frozen_string_literal: true

module V2
  module Sync
    class StatusChangeSyncService < BaseSyncService
      delegate :id, :comment_body, :created_at, :recruit_document, to: :context

      def perform # rubocop:disable Metrics/MethodLength
        return unless context.persisted?

        resp = core_api_client.post(
          "/v2/recruits/#{recruit_document.public_recruit_id}/comments/webhook",
          comment: {
            body: comment_body,
            created_at: created_at,
            change_id: id
          }
        )

        Rails.logger.debug(
          "\e[36mStatus Change Sync  |  #{resp.status}  |  #{id}\e[0m"
        )
      end
    end
  end
end
