# frozen_string_literal: true

module V2
  module Recruitments
    class IndexPresenter
      attr_reader :recruitments

      def initialize(recruitments)
        @recruitments = recruitments.order(created_at: :desc)
      end

      def users
        @users ||= User.all
      end

      def total_pages
        @recruitments.total_pages
      end

      def candidates
        RecruitmentCandidate
          .includes(:recruit_document)
          .where(recruitment_id: @recruitments.ids)
          .order(priority: :desc, position: :asc)
      end
    end
  end
end
