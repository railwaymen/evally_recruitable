# frozen_string_literal: true

module V2
  module RecruitmentCandidates
    class MoveForm
      include ActiveModel::Validations

      attr_reader :recruitment_candidate

      delegate :recruitment, to: :recruitment_candidate

      validate :completed_recruitment
      validate :existing_stage

      def initialize(recruitment_candidate, params:)
        @recruitment_candidate = recruitment_candidate
        @position = params.fetch('position', 0)

        @recruitment_candidate.assign_attributes(params.except('position'))
      end

      def save
        validate_recruitment_candidate!

        @recruitment_candidate.save && @recruitment_candidate.insert_at(@position.to_i)
      end

      def valid?
        @recruitment_candidate.valid? & super
        @recruitment_candidate.errors.blank?
      end

      private

      def validate_recruitment_candidate!
        return if valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruitment_candidate.errors.full_messages
        )
      end

      def completed_recruitment
        return unless recruitment.completed?

        @recruitment_candidate.errors.add(:recruitment, 'has been already completed')
      end

      def existing_stage
        return if recruitment.stages.include? @recruitment_candidate.stage

        @recruitment_candidate.errors.add(:stage, :invalid)
      end
    end
  end
end
