# frozen_string_literal: true

class RecruitmentParticipant < ApplicationRecord
  # # Associations
  #
  belongs_to :recruitment
  belongs_to :user

  # # Validations
  #
  validates :user_id, uniqueness: { scope: %i[recruitment_id] }
end
