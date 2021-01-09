# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexView < Blueprinter::Base
      fields :groups, :total_count

      field :recruit_documents, default: [] do |presenter, options|
        next if presenter.recruit_documents.blank?

        V2::RecruitDocuments::Serializer.render_as_hash(presenter.recruit_documents, **options)
      end

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []

      association :evaluators, blueprint: V2::Users::Serializer, default: []
    end
  end
end
