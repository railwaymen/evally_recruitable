# frozen_string_literal: true

module V2
  module RecruitDocuments
    class Serializer < Blueprinter::Base
      USER_POLICY = ->(user) { user.present? && (user.admin? || user.recruiter?) }

      identifier :id

      fields :first_name, :last_name, :gender, :email, :phone, :group, :position, :source,
             :received_at, :accept_current_processing, :accept_future_processing,
             :public_recruit_id, :task_sent_at, :call_scheduled_at, :interview_scheduled_at,
             :incomplete_details, :rejection_reason, :evaluator_token, :social_links,
             :availability, :available_since, :location, :work_type, :message

      field :evaluator_fullname do |recruit_document|
        recruit_document.evaluator&.fullname
      end

      field :status do |recruit_document|
        status_item = V2::RecruitDocuments::StatusManagerService.find(recruit_document.status)

        V2::RecruitDocuments::StatusSerializer.render_as_hash(status_item)
      end

      field :salary do |recruit_document, options|
        USER_POLICY.call(options[:user]) ? recruit_document.salary : nil
      end

      field :contract_type do |recruit_document, options|
        USER_POLICY.call(options[:user]) ? recruit_document.contract_type : nil
      end
    end
  end
end
