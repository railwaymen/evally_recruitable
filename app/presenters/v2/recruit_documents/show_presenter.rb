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

      def attachments
        @recruit_document.files.attachments if @recruit_document.present?
      end
    end
  end
end
