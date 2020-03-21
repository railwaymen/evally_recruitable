# frozen_string_literal: true

module V2
  module RecruitDocuments
    class BasicForm
      attr_reader :recruit_document

      def initialize(recruit_document, params:)
        @recruit_document = recruit_document

        @recruit_document.assign_attributes(params)
      end

      def save
        validate_recruit_document!

        @recruit_document.save!
      end

      private

      def validate_recruit_document!
        return if @recruit_document.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruit_document.errors.full_messages
        )
      end
    end
  end
end
