# frozen_string_literal: true

class AuthenticationService
  attr_reader :current_user

  def initialize(token)
    @token = token
    @current_user = nil
  end

  def call
    unauthorized! if payload_api_key.blank? || payload_api_key != api_key

    @current_user = User.new(id: payload.fetch('id'), role: payload.fetch('role'))
  rescue ::JWT::ExpiredSignature, ::JWT::VerificationError, ::JWT::DecodeError, KeyError
    unauthorized!
  end

  private

  def api_key
    Rails.application.credentials.evally.fetch(:api_key)
  end

  def payload
    @payload ||= JwtService.decode(@token)
  end

  def payload_api_key
    payload.fetch('api_key')
  end

  def unauthorized!
    raise ErrorResponderService.new(:unauthorized, 401)
  end
end
