# frozen_string_literal: true

module V2
  module Users
    class Serializer < Blueprinter::Base
      identifier :id

      fields :email, :first_name, :last_name, :role, :status, :email_token
    end
  end
end
