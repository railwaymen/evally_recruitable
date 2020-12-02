# frozen_string_literal: true

module V2
  module InboundEmails
    class IndexPresenter
      delegate :total_count, to: :inbound_emails_table_query

      def initialize(scope, params: {})
        @scope = scope
        @params = params
      end

      def inbound_emails
        inbound_emails_table_query.paginated_scope
      end

      private

      def inbound_emails_table_query
        @inbound_emails_table_query ||=
          V2::Shared::ServerSideTableQuery.new(
            extended_scope,
            params: @params,
            custom_columns: ['parsed']
          )
      end

      def extended_scope
        V2::InboundEmails::ExtendedQuery.new(@scope)
      end
    end
  end
end
