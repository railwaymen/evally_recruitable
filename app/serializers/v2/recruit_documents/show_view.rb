# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ShowView < Blueprinter::Base
      fields :positions, :groups

      association :recruit_document, blueprint: V2::RecruitDocuments::Serializer, default: {}

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []

      association :attachments, blueprint: V2::Attachments::Serializer, default: []
    end
  end
end
