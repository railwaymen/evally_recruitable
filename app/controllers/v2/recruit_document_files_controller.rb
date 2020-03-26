# frozen_string_literal: true

module V2
  class RecruitDocumentFilesController < ApplicationController
    def create
      recruit_document.files.attach(recruit_document_params[:files])

      render(
        json: V2::RecruitDocuments::FileSerializer.render(recruit_document.files.last),
        status: :created
      )
    end

    def destroy
      file.purge

      head :no_content
    end

    private

    def file
      @file ||= recruit_document.files.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @file

      @file
    end

    def recruit_document
      @recruit_document ||= RecruitDocument.find_by(id: params[:recruit_document_id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruit_document

      @recruit_document
    end

    def recruit_document_params
      params.require(:recruit_document).permit(files: [])
    end
  end
end
