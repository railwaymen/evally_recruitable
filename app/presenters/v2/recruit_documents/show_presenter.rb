# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ShowPresenter
      attr_reader :recruit_document

      def initialize(recruit_document = nil)
        @recruit_document = recruit_document
      end

      def statuses
        V2::RecruitDocuments::StatusManagerService.statuses
      end

      def groups
        RecruitDocument.distinct(:group).order(:group).pluck(:group)
      end

      def positions
        RecruitDocument.distinct(:position).order(:position).pluck(:position)
      end

      def sources
        RecruitDocument.distinct(:source).order(:source).pluck(:source)
      end

      def attachments
        @recruit_document.files.attachments if @recruit_document.present?
      end

      def current_recruitments
        @recruit_document.recruitments.not_completed if @recruit_document.present?
      end

      def ongoing_recruitments
        Recruitment.not_completed.order(name: :asc)
      end
    end
  end
end
