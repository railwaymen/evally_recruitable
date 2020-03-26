# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ShowPresenter
      attr_reader :recruit_document

      def initialize(recruit_document)
        @recruit_document = recruit_document
      end

      def files
        @recruit_document.files.attachments
      end
    end
  end
end
