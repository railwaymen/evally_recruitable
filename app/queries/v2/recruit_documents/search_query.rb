# frozen_string_literal: true

module V2
  module RecruitDocuments
    class SearchQuery
      def initialize(scope, params:)
        @scope = scope.unscope(:order)
        @params = params
      end

      def call
        @scope
          .select('DISTINCT ON(email) *')
          .where(public_recruit_id: @params[:public_recruit_ids])
          .order(email: :asc, received_at: :desc)
      end
    end
  end
end
