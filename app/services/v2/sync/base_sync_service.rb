# frozen_string_literal: true

module V2
  module Sync
    class BaseSyncService
      attr_reader :context

      def initialize(context, user)
        @context = context
        @user = user
      end

      private

      def core_api_client
        @core_api_client ||= ApiClientService.new(
          @user, Rails.application.config.env.fetch(:core).fetch(:host)
        )
      end
    end
  end
end
