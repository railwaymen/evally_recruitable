# frozen_string_literal: true

module V2
  module Sync
    class StatusChangesJob < ApplicationJob
      def perform(change_id, current_user_id)
        status_change = Change.find_by(id: change_id, context: :status)
        current_user = User.find_by(id: current_user_id)

        V2::Sync::StatusChangeSyncService.new(status_change, current_user).perform
      end
    end
  end
end
