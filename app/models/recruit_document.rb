# frozen_string_literal: true

class RecruitDocument < ApplicationRecord
  # # Scopes
  #
  scope :by_group, proc { |val| where(group: val) if val.present? }
  scope :by_status, proc { |val| where(status: val) if val.present? }

  # # Validations
  #
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :first_name, :last_name, :status, :position, :group, :received_at,
            :accept_current_processing, presence: true

  validates :task_sent_at, presence: true, if: :recruitment_task_status?
  validates :call_scheduled_at, presence: true, if: :phone_call_status?
  validates :interview_scheduled_at, presence: true, if: :office_interview_status?
  validates :decision_made_at, presence: true, if: :decision_was_made?
  validates :recruit_accepted_at, presence: true, if: :hired_status?
  validates :rejection_reason, presence: true, if: :rejection_reason_required?

  # # Enums
  #
  enum status: RecruitDocuments::StatusesManagerService.enum, _suffix: true

  def public_recruit_id
    Digest::SHA256.hexdigest(email)
  end

  private

  def decision_was_made?
    %w[awaiting_response rejected].include? status
  end

  def rejection_reason_required?
    %w[rejected black_list].include? status
  end
end
