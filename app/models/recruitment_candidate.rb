# frozen_string_literal: true

class RecruitmentCandidate < ApplicationRecord
  # # Associations
  #
  belongs_to :recruitment
  belongs_to :recruit_document

  # # Validations
  #
  validates :stage, presence: true
end
