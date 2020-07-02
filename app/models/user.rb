# frozen_string_literal: true

class User < ApplicationRecord
  # # Associations
  #
  has_many :recruit_documents, foreign_key: :evaluator_token, primary_key: :email_token,
                               inverse_of: :evaluator, dependent: :nullify

  # # Validation
  #
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  validates :first_name, :last_name, :role, :status, :email_token, presence: true

  # # Scopes
  #
  scope :active_admin_other_than, ->(id) { active.admin.where.not(id: id) }
  scope :active_recruiter_other_than, ->(id) { active.recruiter.where.not(id: id) }

  # # Enums
  #
  enum role: { admin: 'admin', evaluator: 'evaluator', recruiter: 'recruiter' }
  enum status: { active: 'active', inactive: 'inactive' }

  # # Callbacks
  #
  before_validation :set_email_token

  # # Methods
  #

  def set_email_token
    self.email_token = Digest::SHA256.hexdigest(email.to_s)
  end

  def fullname
    "#{first_name} #{last_name}".strip
  end

  def mail_to
    "#{fullname} <#{email}>"
  end
end
