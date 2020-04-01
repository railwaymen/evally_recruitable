# frozen_string_literal: true

class Change < ApplicationRecord
  store :details

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

  def recruit_document_type?
    changeable_type == 'RecruitDocument'
  end

  def recruit_document
    changeable if recruit_document_type?
  end

  private

  def comment_beginning
    return I18n.t("change.#{context}.to", to: to.titleize) if from.blank?

    I18n.t("change.#{context}.from_to", from: from.titleize, to: to.titleize)
  end

  def listed_details
    details.map do |k, v|
      I18n.t("change.#{context}.detail", label: k.titleize, value: formatted_detail_value(v))
    end
  end

  def formatted_detail_value(val)
    return val.to_s unless val.is_a?(ActiveSupport::TimeWithZone)

    val.localtime.strftime('%Y-%m-%d %H:%M %Z')
  end
end
