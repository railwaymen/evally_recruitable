# frozen_string_literal: true

module V2
  module InboundEmails
    class IndexPresenter
      def initialize(scope, params:)
        @scope = scope
        @params = params
      end

      def inbound_emails
        V2::InboundEmails::ExtendedQuery
          .new(@scope.page(@params[:page]).per(@params[:per_page]))
          .order(order_rule)
      end

      def total_count
        @scope.count
      end

      private

      def order_rule
        return 'created_at desc' unless %w[status created_at parsed].include?(@params[:sort_by])

        "#{@params[:sort_by]} #{@params[:sort_dir] == 'asc' ? 'asc' : 'desc'}"
      end
    end
  end
end
