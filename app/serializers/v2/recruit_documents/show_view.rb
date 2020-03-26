# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ShowView < Blueprinter::Base
      association :recruit_document, blueprint: V2::RecruitDocuments::Serializer, default: {}

      association :files, blueprint: V2::RecruitDocuments::FileSerializer, default: []
    end
  end
end
