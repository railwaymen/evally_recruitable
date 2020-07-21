# frozen_string_literal: true

module V2
  module Sync
    class RecruitSyncService < BaseSyncService
      delegate :public_recruit_id, :evaluator_token, to: :resource

      def perform # rubocop:disable Metrics/MethodLength
        return unless resource&.persisted?

        resp = api_client.post(
          '/v2/recruits/webhook',
          recruit: {
            public_recruit_id: public_recruit_id,
            evaluator_token: evaluator_token
          }
        )

        Rails.logger.info(
          "\e[35mRecruit Sync  |  #{resp.status}  |  #{public_recruit_id}\e[0m"
        )
      end
    end
  end
end
