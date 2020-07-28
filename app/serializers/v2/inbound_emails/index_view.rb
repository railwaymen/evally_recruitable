# frozen_string_literal: true

module V2
  module InboundEmails
    class IndexView < Blueprinter::Base
      fields :total_count

      association :inbound_emails, blueprint: V2::InboundEmails::Serializer, default: []
    end
  end
end
