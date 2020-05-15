# frozen_string_literal: true

module V2
  module RecruitDocuments
    class SearchQuery
      def self.call(scope = RecruitDocument.all, params:)
        @params = params

        scope
          .unscope(:order)
          .select('DISTINCT ON(email) *')
          .where(public_recruit_id: params[:public_recruit_ids])
          .order(email: :asc, received_at: :desc)
      end
    end
  end
end
