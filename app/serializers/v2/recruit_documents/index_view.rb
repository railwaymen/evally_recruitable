# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexView < Blueprinter::Base
      association :recruit_documents, blueprint: V2::RecruitDocuments::Serializer, default: []

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []

      fields :groups, :positions
    end
  end
end
