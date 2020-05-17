# frozen_string_literal: true

module V2
  module RecruitDocuments
    class SearchView < Blueprinter::Base
      identifier :id

      fields :first_name, :last_name, :group, :position, :source, :received_at,
             :accept_current_processing, :accept_future_processing, :public_recruit_id

      field :status do |recruit_document|
        status_item = V2::RecruitDocuments::StatusManagerService.find(recruit_document.status)

        V2::RecruitDocuments::StatusSerializer.render_as_hash(status_item)
      end
    end
  end
end
