# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexView < Blueprinter::Base
      fields :groups, :positions

      association :recruit_documents, blueprint: V2::RecruitDocuments::Serializer, default: []

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []
    end
  end
end
