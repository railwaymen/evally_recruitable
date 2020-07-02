# frozen_string_literal: true

module V2
  module RecruitDocuments
    class EvaluatorAssignerService
      attr_reader :recruit_document

      delegate :evaluator, to: :recruit_document

      def initialize(recruit_document, user)
        @recruit_document = recruit_document
        @user = user
      end

      def call
        return unless evaluator_change

        previous_documents.update_all(evaluator_token: @recruit_document.evaluator_token)
      end

      def notify
        return unless evaluator_change && evaluator.present?

        notification_recipients.map do |recipient|
          NotificationMailer
            .with(recruit_document: @recruit_document, recipient: recipient, user: @user)
            .evaluator_assignment
            .deliver_later
        end
      end

      private

      def evaluator_change
        @evaluator_change ||= @recruit_document.evaluator_token_changed?
      end

      def previous_documents
        RecruitDocument.where(email: @recruit_document.email)
      end

      def notification_recipients
        User.where(id: [evaluator&.id, *other_recruiters.ids].compact.uniq)
      end

      def other_recruiters
        User.active_recruiter_other_than(@user.id)
      end
    end
  end
end
