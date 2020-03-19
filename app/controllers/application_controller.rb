# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate!

  rescue_from ErrorResponderService, with: :render_error_response

  private

  def authenticate!
    AuthenticationService.new(token).call
  end

  def render_error_response(error)
    render json: V2::Errors::Serializer.render(error), status: error.status
  end

  def token
    request.headers.fetch('Token', '').split(' ').last
  end
end
