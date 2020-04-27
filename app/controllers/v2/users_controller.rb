# frozen_string_literal: true

module V2
  class UsersController < ApplicationController
    def webhook
      user = User.find_or_initialize_by(email: webhook_params[:email])
      user.assign_attributes(webhook_params)

      head user.save ? :no_content : :unprocessable_entity
    end

    private

    def webhook_params
      params.require(:user).permit(:id, :email, :first_name, :last_name, :role, :status)
    end
  end
end
