# frozen_string_literal: true

module V2
  module RecruitmentCandidates
    class Serializer < Blueprinter::Base
      identifier :id

      fields :stage, :priority, :recruit_document_id

      field :first_name do |candidate|
        candidate.recruit_document.first_name
      end

      field :last_name do |candidate|
        candidate.recruit_document.last_name
      end

      field :position do |candidate|
        candidate.recruit_document.position
      end

      field :received_at do |candidate|
        candidate.recruit_document.received_at
      end

      field :public_recruit_id do |candidate|
        candidate.recruit_document.public_recruit_id
      end

      field :evaluator_token do |candidate|
        candidate.recruit_document.evaluator_token
      end

      field :status do |candidate|
        status_item =
          V2::RecruitDocuments::StatusManagerService.find(candidate.recruit_document.status)

        V2::RecruitDocuments::StatusSerializer.render_as_hash(status_item)
      end
    end
  end
end
