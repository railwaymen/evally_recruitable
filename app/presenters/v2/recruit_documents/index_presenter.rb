# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexPresenter
      attr_reader :recruit_documents

      def initialize(recruit_documents)
        @recruit_documents = recruit_documents
      end

      def groups
        RecruitDocument.distinct(:group).order(:group).pluck(:group)
      end

      def statuses
        RecruitDocument.distinct(:status).order(:status).pluck(:status)
      end
    end
  end
end
