# frozen_string_literal: true

module V2
  module RecruitDocuments
    class BasicForm
      attr_reader :recruit_document

      def initialize(recruit_document, params:, user:)
        @recruit_document = recruit_document
        @user = user

        @recruit_document.assign_attributes(
          status: params.dig('status', 'value') || recruit_document.status,
          **params.except('status')
        )
      end

      def save
        validate_recruit_document!

        ActiveRecord::Base.transaction do
          assign_evaluator_to_other_recruit_documents
          status_change_logger.save! if @recruit_document.status_change_commentable?

          @recruit_document.save!
        end

        recruit_sync.perform
        status_change_sync.perform
      end

      private

      def validate_recruit_document!
        return if @recruit_document.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruit_document.errors.full_messages
        )
      end

      def assign_evaluator_to_other_recruit_documents
        return if @recruit_document.persisted? && !@recruit_document.evaluator_id_changed?

        RecruitDocument
          .where('email = ?', @recruit_document.email)
          .update_all(evaluator_id: @recruit_document.evaluator_id)
      end

      def status_change_logger
        @status_change_logger ||=
          V2::RecruitDocuments::StatusChangeLoggerService.new(@recruit_document)
      end

      def recruit_sync
        @recruit_sync ||= V2::Sync::RecruitSyncService.new(@recruit_document, @user)
      end

      def status_change_sync
        @status_change_sync ||=
          V2::Sync::StatusChangeSyncService.new(status_change_logger.status_change, @user)
      end
    end
  end
end
