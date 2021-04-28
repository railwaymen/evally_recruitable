# frozen_string_literal: true

module V2
  module Recruitments
    class AddStageForm
      include ActiveModel::Validations

      attr_reader :recruitment

      validate :stage_presence
      validate :stage_uniqueness

      def initialize(recruitment, stage:)
        @recruitment = recruitment
        @stage = stage
      end

      def save
        validate_recruitment_and_stage!
        @recruitment.stages << @stage

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

      def stage_uniqueness
        return if @recruitment.stages.exclude?(@stage)

        @recruitment.errors.add(:base, 'Stage has already been taken')
      end

      def stage_presence
        return if @stage.present?

        @recruitment.errors.add(:base, 'Stage can\'t be blank')
      end
    end
  end
end
