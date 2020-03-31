# frozen_string_literal: true

class Change < ApplicationRecord
  # Associations
  #
  belongs_to :changeable, polymorphic: true

  # Validations
  #
  validates :context, :from, :to, presence: true
end
