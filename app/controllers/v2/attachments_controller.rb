# frozen_string_literal: true

module V2
  class AttachmentsController < ApplicationController
    def create
      recruit_document.files.attach(params[:files])

      render(
        json: V2::Attachments::Serializer.render(recruit_document.files.attachments),
        status: :created
      )
    end

    def destroy
      attachment.purge

      head :no_content
    end

    private

    def attachment
      @attachment ||= recruit_document.files.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @attachment

      @attachment
    end

    def recruit_document
      @recruit_document ||= RecruitDocument.find_by(id: params[:recruit_document_id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruit_document

      @recruit_document
    end
  end
end
