# frozen_string_literal: true

class RecruitDocument < ApplicationRecord
  # # Associations
  #
  has_many_attached :files

  has_many :status_changes, -> { where(context: 'status') },
           as: :changeable, class_name: 'Change', inverse_of: :changeable

  # # Scopes
  #
  scope :by_group, proc { |val| where(group: val) if val.present? }
  scope :by_status, proc { |val| where(status: val) if val.present? }

  # # Validations
  #
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :first_name, :status, :position, :group, :received_at,
            :accept_current_processing, :public_recruit_id, presence: true

  validates :incomplete_details, presence: true, if: :incomplete_documents_status?
  validates :task_sent_at, presence: true, if: :recruitment_task_status?
  validates :call_scheduled_at, presence: true, if: :phone_call_status?
  validates :interview_scheduled_at, presence: true, if: :office_interview_status?
  validates :rejection_reason, presence: true, if: :rejection_reason_required?

  # # Enums
  #
  enum status: V2::RecruitDocuments::StatusManagerService.enum, _suffix: true

  # # Callbacks
  #
  before_validation :set_public_recruit_id

  def status_change_commentable?
    persisted? && (
      changes.keys &
        %w[
          status task_sent_at call_scheduled_at interview_scheduled_at incomplete_details
          rejection_reason
        ]
    ).any?
  end

  private

  def rejection_reason_required?
    %w[rejected black_list].include? status
  end

  def set_public_recruit_id
    self.public_recruit_id = Digest::SHA256.hexdigest(email.to_s)
  end
end
