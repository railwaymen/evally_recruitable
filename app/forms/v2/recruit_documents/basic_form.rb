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

      def save # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        validate_recruit_document!

        ActiveRecord::Base.transaction do
          evaluator_assigner.call
          status_change_logger.call

          @recruit_document.save!
          @recruit_document.files.attach(@files) if @files.present?
        end

        evaluator_assigner.notify
        status_change_logger.notify

        recruit_sync.perform
        evaluator_assigner.sync
        status_change_logger.sync
      end

      private

      def validate_recruit_document!
        return if @recruit_document.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruit_document.errors.full_messages
        )
      end

      def evaluator_assigner
        @evaluator_assigner ||=
          V2::RecruitDocuments::EvaluatorAssignerService.new(@recruit_document, @user)
      end

      def status_change_logger
        @status_change_logger ||=
          V2::RecruitDocuments::StatusChangeLoggerService.new(@recruit_document, @user)
      end

      def recruit_sync
        @recruit_sync ||= V2::Sync::RecruitSyncService.new(@recruit_document, @user)
      end
    end
  end
end
