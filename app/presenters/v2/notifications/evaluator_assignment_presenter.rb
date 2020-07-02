# frozen_string_literal: true

module V2
  module Notifications
    class EvaluatorAssignmentPresenter
      attr_reader :recruit_document

      def initialize(recruit_document)
        @recruit_document = recruit_document
      end

      def evaluator
        @evaluator ||= User.find_by(email_token: @recruit_document.evaluator_token)
      end

      def status
        @status ||= V2::RecruitDocuments::StatusManagerService.find(@recruit_document.status)
      end
    end
  end
end
