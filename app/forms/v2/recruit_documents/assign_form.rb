# frozen_string_literal: true

module V2
  module RecruitDocuments
    class AssignForm
      include ActiveModel::Validations

      attr_reader :recruit_document

      validate :existing_stage

      def initialize(recruit_document, params:)
        @recruit_document = recruit_document
        @params = params
      end

      def save
        validate_recruitment_candidate!

        recruitment_candidate.save
      end

      def valid?
        recruitment_candidate.valid? & super
        recruitment_candidate.errors.blank?
      end

      private

      def validate_recruitment_candidate!
        return if valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruitment_candidate.errors.full_messages
        )
      end

      def recruitment_candidate
        @recruitment_candidate ||=
          RecruitmentCandidate.new(
            recruit_document: @recruit_document,
            recruitment: recruitment,
            stage: @params[:stage]
          )
      end

      def recruitment
        @recruitment ||= Recruitment.not_completed.find_by(id: @params[:recruitment_id])
        raise ErrorResponderService.new(:record_not_found, 404) unless @recruitment

        @recruitment
      end

      def existing_stage
        return if recruitment.stages.include? @params[:stage]

        recruitment_candidate.errors.add(:stage, :invalid)
      end
    end
  end
end
