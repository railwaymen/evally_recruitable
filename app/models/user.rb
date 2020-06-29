# frozen_string_literal: true

class User < ApplicationRecord
  # # Validation
  #
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  validates :first_name, :last_name, :role, :status, presence: true

  # # Enums
  #
  enum role: { admin: 'admin', evaluator: 'evaluator', recruiter: 'recruiter' }
  enum status: { active: 'active', inactive: 'inactive' }

  def email_token
    Digest::SHA256.hexdigest(email.to_s)
  end
end
