# frozen_string_literal: true

module VueRoutesHelper
  def vue_recruit_document_url(resource)
    "#{host}/app/recruitments/#{resource.public_recruit_id}/documents/#{resource.id}"
  end

  def host
    Rails.application.config.env.fetch(:core).fetch(:host)
  end
end
