# frozen_string_literal: true

module V2
  module Notifications
    class EvaluatorAssignmentPresenter
      attr_reader :recruit_document, :user

      def initialize(recruit_document, user)
        @recruit_document = recruit_document
        @user = user
      end

      def evaluator
        @evaluator ||= User.find_by(email_token: @recruit_document.evaluator_token)
      end

      def status
        @status ||= V2::RecruitDocuments::StatusManagerService.find(@recruit_document.status)
      end

      def mail_subject
        "#{recruit_document.safe_recruit_name} | #{recruit_document.position} | Evaluator Assignment News" # rubocop:disabled Layout/LineLength
      end
    end
  end
end
