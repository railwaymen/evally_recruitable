# frozen_string_literal: true

class User
  attr_reader :id, :role

  def initialize(id:, role:)
    @id = id.to_i
    @role = role.to_s
  end

  def present?
    id.positive?
  end

  def blank?
    id.zero?
  end

  def admin?
    role == 'admin'
  end

  def recruiter?
    role == 'recruiter'
  end

  def evaluator?
    role == 'evaluator'
  end
end
