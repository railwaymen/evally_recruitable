# frozen_string_literal: true

module V2
  class InboundEmailsController < ApplicationController
    def index
      inbound_emails = inbound_emails_scope.order(created_at: :desc)

      render json: V2::InboundEmails::Serializer.render(inbound_emails), status: :ok
    end

    private

    def inbound_emails_scope
      V2::InboundEmails::ExtendedQuery.new(ActionMailbox::InboundEmail.all)
    end
  end
end
