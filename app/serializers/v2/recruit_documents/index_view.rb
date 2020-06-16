# frozen_string_literal: true

module V2
  module RecruitDocuments
    class IndexView < Blueprinter::Base
      fields :groups

      field :recruit_documents, default: [] do |presenter, options|
        next if presenter.recruit_documents.blank?

        V2::RecruitDocuments::Serializer.render_as_hash(
          presenter.recruit_documents,
          user: options[:user]
        )
      end

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []
    end
  end
end
