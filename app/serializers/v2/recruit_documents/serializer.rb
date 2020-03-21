# frozen_string_literal: true

module V2
  module RecruitDocuments
    class Serializer < Blueprinter::Base
      identifier :id

      fields :first_name, :last_name, :gender, :email, :phone, :group, :position, :source,
             :received_at, :status, :accept_current_processing, :accept_future_processing

      field :public_recruit_id do |recruit_document|
        Digest::SHA256.hexdigest(recruit_document.email)
      end
    end
  end
end
