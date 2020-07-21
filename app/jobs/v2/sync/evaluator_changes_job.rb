# frozen_string_literal: true

module V2
  module Sync
    class EvaluatorChangesJob < ApplicationJob
      def perform(change_id, current_user_id)
        evaluator_change = Change.find_by(id: change_id, context: :evaluator)
        current_user = User.find_by(id: current_user_id)

        V2::Sync::EvaluatorChangeSyncService.new(evaluator_change, current_user).perform
      end
    end
  end
end
