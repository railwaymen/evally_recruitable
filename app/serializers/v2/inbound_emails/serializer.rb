# frozen_string_literal: true

module V2
  module InboundEmails
    class Serializer < Blueprinter::Base
      identifier :id

      fields :status, :message_id, :created_at

      field :parsed do |inbound_email|
        inbound_email.respond_to?(:parsed) ? inbound_email.parsed : nil
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
