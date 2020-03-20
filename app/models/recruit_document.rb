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

  # # Enums
  #
  enum status: {
    received: 'received'
  }
end
