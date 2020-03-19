# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    render json: { message: 'Hello Evally Recruitable!' }.to_json, status: :ok
  end
end
