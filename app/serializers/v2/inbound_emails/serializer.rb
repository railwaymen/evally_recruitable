# frozen_string_literal: true

module V2
  module InboundEmails
    class Serializer < Blueprinter::Base
      identifier :id

      fields :message_id, :created_at

      field :status do |inbound_email|
        inbound_email.parsed? ? 'parsed' : inbound_email.status
      end

      field :source do |inbound_email|
        inbound_email.mail.from.first
      end

      field :subject do |inbound_email|
        inbound_email.mail.subject
      end
    end
  end
end
