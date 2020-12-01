# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexPresenter
      delegate :total_count, to: :recruit_documents_table_query

      def initialize(recruit_documents, params:)
        @recruit_documents = recruit_documents.includes(:evaluator)
        @params = params
      end

      def recruit_documents
        recruit_documents_table_query.paginated_scope
      end

      def statuses
        V2::RecruitDocuments::StatusManagerService.statuses
      end

      def groups
        RecruitDocument.distinct(:group).order(:group).pluck(:group)
      end

      def evaluators
        User.all
      end

      private

      def recruit_documents_table_query
        @recruit_documents_table_query ||=
          V2::Shared::ServerSideTableQuery.new(@recruit_documents, params: @params)
      end
    end
  end
end
