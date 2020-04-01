# frozen_string_literal: true

module V2
  module RecruitDocuments
    class StatusChangeLoggerService
      attr_reader :status_change

      delegate :save!, to: :status_change

      def initialize(recruit_document)
        @recruit_document = recruit_document

        @status_change = @recruit_document.status_changes.build(
          from: @recruit_document.status_was,
          to: @recruit_document.status,
          details: resolve_details
        )
      end

      private

      def current_status
        @current_status ||=
          V2::RecruitDocuments::StatusManagerService.find(@recruit_document.status)
      end

      def resolve_details
        return {} if current_status.blank?

        @recruit_document.attributes.slice(
          *current_status.required_fields.collect { |field| field.value.to_s }
        )
      end
    end
  end
end
