# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    include ActionController::Helpers

    helper_method :current_user

    private

    def authenticate!
      authentication_service.call
    end

    def authentication_service
      @authentication_service ||= AuthenticationService.new(token)
    end

    def current_user
      authentication_service.current_user
    end

    def token
      request.headers.fetch('Token', '').split(' ').last
    end
  end
end
