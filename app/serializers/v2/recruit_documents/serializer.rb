# frozen_string_literal: true

module V2
  module RecruitDocuments
    class Serializer < Blueprinter::Base
      identifier :id

      fields :first_name, :last_name, :gender, :email, :phone, :group, :position, :source,
             :received_at, :accept_current_processing, :accept_future_processing,
             :public_recruit_id, :task_sent_at, :call_scheduled_at, :interview_scheduled_at,
             :decision_made_at, :recruit_accepted_at, :rejection_reason, :evaluator_id

      field :status do |recruit_document|
        status_item = ::RecruitDocuments::StatusesManagerService.find(recruit_document.status)

        V2::RecruitDocuments::StatusSerializer.render_as_hash(status_item)
      end
    end
  end
end
