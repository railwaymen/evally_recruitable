# frozen_string_literal: true

module V2
  module Sync
    class EvaluatorChangeSyncService < BaseSyncService
      delegate :id, :to, :created_at, :recruit_document, :user, to: :resource

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
          "\e[36mEvaluator Change Sync  |  #{resp.status}  |  #{id}\e[0m"
        )
      end

      private

      def comment_body
        return I18n.t('change.evaluator.blank', actor_name: actor_name) if evaluator.blank?

        I18n.t('change.evaluator.to', actor_name: actor_name, name: evaluator.fullname)
      end

      def evaluator
        @evaluator ||= User.find_by(email_token: to)
      end

      def actor_name
        user.present? ? user.fullname : 'Somebody'
      end
    end
  end
end
