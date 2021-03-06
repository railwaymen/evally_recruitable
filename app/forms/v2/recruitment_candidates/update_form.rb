# frozen_string_literal: true

module V2
  module RecruitmentCandidates
    class UpdateForm
      include ActiveModel::Validations

      attr_reader :recruitment_candidate

      delegate :recruitment, to: :recruitment_candidate

      validate :completed_recruitment

      def initialize(recruitment_candidate, params:)
        @recruitment_candidate = recruitment_candidate

        @recruitment_candidate.assign_attributes(params)
      end

      def save
        validate_recruitment_candidate!

        @recruitment_candidate.save
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
    end
  end
end
