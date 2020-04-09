# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexPresenter
      attr_reader :recruit_documents

      def initialize(recruit_documents)
        @recruit_documents = recruit_documents
      end

      def statuses
        V2::RecruitDocuments::StatusManagerService.statuses
      end

      def groups
        RecruitDocument.distinct(:group).order(:group).pluck(:group)
      end
    end
  end
end
