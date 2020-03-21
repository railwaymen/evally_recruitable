# frozen_string_literal: true

module V2
  class RecruitDocumentsController < ApplicationController
    def index
      presenter = V2::RecruitDocuments::IndexPresenter.new(
        recruit_documents_scope.by_group(params.dig(:group)).by_status(params.dig(:status))
      )

      render json: V2::RecruitDocuments::IndexView.render(presenter), status: :ok
    end

    def show
      render json: V2::RecruitDocuments::Serializer.render(recruit_document), status: :ok
    end

    def form
      presenter = V2::RecruitDocuments::FormPresenter.new

      render json: V2::RecruitDocuments::FormView.render(presenter), status: :ok
    end

    def create
      create_form.save

      render(
        json: V2::RecruitDocuments::Serializer.render(create_form.recruit_document),
        status: :created
      )
    end

    def update
      update_form.save

      render(
        json: V2::RecruitDocuments::Serializer.render(update_form.recruit_document),
        status: :ok
      )
    end

    private

    def recruit_documents_scope
      RecruitDocument.all
    end

    def recruit_document
      @recruit_document ||= RecruitDocument.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruit_document

      @recruit_document
    end

    def create_form
      @create_form ||= V2::RecruitDocuments::BasicForm.new(
        RecruitDocument.new,
        params: recruit_document_params
      )
    end

    def update_form
      @update_form ||= V2::RecruitDocuments::BasicForm.new(
        recruit_document,
        params: recruit_document_params
      )
    end

    def recruit_document_params
      params.require(:recruit_document).permit(
        :first_name, :last_name, :gender, :email, :phone, :position, :group, :received_at, :source,
        :status, :accept_current_processing, :accept_future_processing
      )
    end
  end
end
