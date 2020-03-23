# frozen_string_literal: true

module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def sign_in(user)
    request.headers['Token'] = JwtService.encode(user)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :controller
end
