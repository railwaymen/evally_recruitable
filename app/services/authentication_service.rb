# frozen_string_literal: true

class AuthenticationService
  def initialize(token)
    @token = token
  end

  def call
    payload_api_key = JwtService.decode(@token).fetch('api_key', '')

    (payload_api_key.present? && payload_api_key == api_key) || unauthorized!
  rescue ::JWT::ExpiredSignature, ::JWT::VerificationError, ::JWT::DecodeError
    unauthorized!
  end

  private

  def api_key
    Rails.application.credentials.evally.fetch(:api_key)
  end

  def unauthorized!
    raise ErrorResponderService.new(:unauthorized, 401)
  end
end
