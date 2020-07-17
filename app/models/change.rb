# frozen_string_literal: true

class Change < ApplicationRecord
  store :details

  # Associations
  #
  belongs_to :changeable, polymorphic: true

  # Validations
  #

  validates :context, presence: true
  validates :to, presence: true, if: :status_context?

  # Enums
  #

  enum context: { evaluator: 'evaluator', status: 'status' }, _suffix: true

  # Methods
  #

  def recruit_document_type?
    changeable_type == 'RecruitDocument'
  end

  def recruit_document
    changeable if recruit_document_type?
  end
end
