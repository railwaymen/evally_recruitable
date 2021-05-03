# frozen_string_literal: true

module V2
  module Recruitments
    class ShowPresenter
      attr_reader :recruitment

      def initialize(recruitment)
        @recruitment = recruitment
      end

      def candidates
        recruitment
          .recruitment_candidates
          .includes(:recruit_document)
          .order(priority: :desc, position: :asc)
      end
    end
  end
end
