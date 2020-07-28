# frozen_string_literal: true

module V2
  class InboundEmailsController < ApplicationController
    def index
      presenter =
        V2::InboundEmails::IndexPresenter.new(ActionMailbox::InboundEmail.all, params: params)

      render json: V2::InboundEmails::IndexView.render(presenter), status: :ok
    end
  end
end
