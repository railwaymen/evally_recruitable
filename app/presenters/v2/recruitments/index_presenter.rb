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
    end
  end
end
