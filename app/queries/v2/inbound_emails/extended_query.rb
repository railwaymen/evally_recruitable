# frozen_string_literal: true

module V2
  module InboundEmails
    class ExtendedQuery
      delegate_missing_to :@scope

      def initialize(scope)
        @scope = scope.select(fields)
      end

      private

      def fields
        "
          action_mailbox_inbound_emails.*,
          EXISTS (
            SELECT 1
            FROM recruit_documents
            WHERE recruit_documents.message_id = action_mailbox_inbound_emails.message_id
          ) AS parsed
        "
      end
    end
  end
end
