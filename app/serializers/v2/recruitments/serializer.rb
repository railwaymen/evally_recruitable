# frozen_string_literal: true

module V2
  module Recruitments
    class Serializer < Blueprinter::Base
      identifier :id

      fields :name, :description, :stages, :status, :started_at, :completed_at

      field :user_tokens do |recruitment|
        recruitment.users.pluck(:email_token)
      end
    end
  end
end
