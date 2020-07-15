# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexPresenter
      def initialize(recruit_documents, params:)
        @recruit_documents = recruit_documents.includes(:evaluator)
        @params = params
      end

      def recruit_documents
        @recruit_documents.where(filter_conditions).order(email: :asc, received_at: :desc)
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

      def filter_conditions
        @params.select { |_key, value| value.present? }
      end
    end
  end
end
