# frozen_string_literal: true

module V2
  module Sync
    class BaseSyncService
      attr_reader :resource

      def initialize(resource, user, service: :core)
        @resource = resource
        @user = user

        @service = service.to_sym
      end

      private

      def api_client
        @api_client ||= ApiClientService.new(
          @user, Rails.application.config.env.fetch(@service).fetch(:host)
        )
      end
    end
  end
end
