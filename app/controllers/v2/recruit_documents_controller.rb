# frozen_string_literal: true

module V2
  class RecruitDocumentsController < ApplicationController
    def index
      recruit_documents = RecruitDocument.all

      render json: V2::RecruitDocuments::Serializer.render(recruit_documents), status: :ok
    end

    def show
      render json: V2::RecruitDocuments::Serializer.render(recruit_document), status: :ok
    end

    private

    def recruit_document
      @recruit_document ||= RecruitDocument.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruit_document

      @recruit_document
    end
  end
end
