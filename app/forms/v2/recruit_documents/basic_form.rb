# frozen_string_literal: true

module V2
  module RecruitDocuments
    class BasicForm
      attr_reader :recruit_document

      def initialize(recruit_document, params:, user:)
        @recruit_document = recruit_document
        @files = params.fetch('files', [])
        @user = user

        @recruit_document.assign_attributes(
          status: params.dig('status', 'value') || recruit_document.status,
          social_links: params.fetch('social_links', '').split(','),
          **params.except('files', 'status', 'social_links')
        )
      end

      def save
        validate_recruit_document!

        ActiveRecord::Base.transaction do
          assign_evaluator_to_other_recruit_documents
          status_change_logger.save! if @recruit_document.status_change_commentable?

          @recruit_document.save!
          @recruit_document.files.attach(@files) if @files.present?
        end

        recruit_sync.perform
        synchronize_status_change
      end

      private

      def validate_recruit_document!
        return if @recruit_document.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruit_document.errors.full_messages
        )
      end

      def assign_evaluator_to_other_recruit_documents
        return if @recruit_document.persisted? && !@recruit_document.evaluator_token_changed?

        RecruitDocument
          .where(email: @recruit_document.email)
          .update_all(evaluator_token: @recruit_document.evaluator_token)
      end

      def status_change_logger
        @status_change_logger ||=
          V2::RecruitDocuments::StatusChangeLoggerService.new(@recruit_document)
      end

      def recruit_sync
        @recruit_sync ||= V2::Sync::RecruitSyncService.new(@recruit_document, @user)
      end

      def synchronize_status_change
        V2::Sync::StatusChangesJob.perform_later(status_change_logger.status_change.id, @user.id)
      end
    end
  end
end
