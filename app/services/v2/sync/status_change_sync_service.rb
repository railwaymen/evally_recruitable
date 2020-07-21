# frozen_string_literal: true

module V2
  module Sync
    class StatusChangeSyncService < BaseSyncService
      delegate :id, :from, :to, :details, :created_at, :recruit_document, :user, to: :resource

      def perform # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        return unless resource&.persisted? && recruit_document.present?

        resp = api_client.post(
          "/v2/recruits/#{recruit_document.public_recruit_id}/comments/webhook",
          comment: {
            body: comment_body,
            created_at: created_at,
            change_id: id,
            recruit_document_id: recruit_document.id
          }
        )

        Rails.logger.info(
          "\e[36mStatus Change Sync  |  #{resp.status}  |  #{id}\e[0m"
        )
      end

      private

      def comment_body
        [comment_beginning, listed_details].compact.join
      end

      def comment_beginning
        return I18n.t('change.status.to', actor_name: actor_name, to: to.titleize) if from.blank?

        I18n.t(
          'change.status.from_to',
          actor_name: actor_name,
          from: from.titleize,
          to: to.titleize
        )
      end

      def listed_details
        return if details.blank?

        list_items = details.map do |k, v|
          I18n.t('change.status.detail', label: k.titleize, value: formatted_detail_value(v))
        end

        "<ul>#{list_items.join}</ul>"
      end

      def formatted_detail_value(val)
        return val.to_s unless val.is_a?(ActiveSupport::TimeWithZone)

        val.localtime.strftime('%d %b %Y, %H:%M %Z')
      end

      def actor_name
        user.present? ? user.fullname : 'Somebody'
      end
    end
  end
end
