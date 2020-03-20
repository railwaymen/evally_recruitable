# frozen_string_literal: true

module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def sign_in
    request.headers['Token'] = JwtService.encode(
      Rails.application.credentials.evally.fetch(:api_key)
    )
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :controller
end
