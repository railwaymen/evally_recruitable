# frozen_string_literal: true

module V2
  class InboundEmailsController < ApplicationController
    def index
      presenter =
        V2::InboundEmails::IndexPresenter.new(ActionMailbox::InboundEmail.all, params: table_params)

      render json: V2::InboundEmails::IndexView.render(presenter), status: :ok
    end

    private

    def table_params
      params.permit(:page, :per_page, :sort_by, :sort_dir)
    end
  end
end
