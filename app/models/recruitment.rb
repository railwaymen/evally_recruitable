# frozen_string_literal: true

class Recruitment < ApplicationRecord
  include AASM

  # # Associations
  #
  has_and_belongs_to_many :recruit_documents, join_table: 'recruitment_candidates'
  has_and_belongs_to_many :users, join_table: 'recruitment_participants'

  # # Validations
  #
  validates :name, :status, presence: true
  validates :started_at, presence: true, if: :started?
  validates :completed_at, presence: true, if: :completed?

  # # Enum
  #
  enum status: {
    draft: 'draft',
    started: 'started',
    completed: 'completed'
  }

  aasm column: :status, enum: true, whiny_transitions: false do
    state :draft, initial: true
    state :started
    state :completed

    event :start, before: :assign_started_attributes do
      transitions from: :draft, to: :started
    end

    event :complete, before: :assign_completed_attributes do
      transitions from: :started, to: :completed
    end
  end

  def candidates_exist_on_stage?(stage)
    RecruitmentCandidate.where(recruitment: self, stage: stage).exists?
  end

  private

  def assign_started_attributes
    assign_attributes(started_at: Time.current)
  end

  def assign_completed_attributes
    assign_attributes(completed_at: Time.current)
  end
end
