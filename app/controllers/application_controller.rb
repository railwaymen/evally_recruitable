# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authenticable

  before_action :authenticate!
  before_action :set_locale

  rescue_from ErrorResponderService, with: :render_error_response

  private

  def render_error_response(error)
    render json: V2::Errors::Serializer.render(error), status: error.status
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
