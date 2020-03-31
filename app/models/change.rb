# frozen_string_literal: true

class Change < ApplicationRecord
  # Associations
  #
  belongs_to :changeable, polymorphic: true

  # Validations
  #

  validates :context, :to, presence: true

  # Methods
  #

  def comment_body
    [comment_beginning, *listed_details].join('\n ')
  end

  private

  def comment_beginning
    return I18n.t("change.#{context}.to", to: to.titleize) if from.blank?

    I18n.t("change.#{context}.from_to", from: from.titleize, to: to.titleize)
  end

  def listed_details
    details.map { |k, v| I18n.t("change.#{context}.detail", label: k.titleize, value: v) }
  end
end
