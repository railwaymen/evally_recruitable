# frozen_string_literal: true

module V2
  module Recruitments
    class DropStageForm
      include ActiveModel::Validations

      attr_reader :recruitment

      validate :assignments_presence

      def initialize(recruitment, stage:)
        @recruitment = recruitment
        @stage = stage
      end

      def save
        validate_recruitment_and_stage!
        @recruitment.stages.delete(@stage)

        @recruitment.save
      end

      def valid?
        @recruitment.valid? & super
        @recruitment.errors.blank?
      end

      private

      def validate_recruitment_and_stage!
        return if valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruitment.errors.full_messages
        )
      end

      def assignments_presence
        return unless @recruitment.candidates_exist_on_stage? @stage

        @recruitment.errors.add(:base, 'Stage has assigned recruits')
      end
    end
  end
end
