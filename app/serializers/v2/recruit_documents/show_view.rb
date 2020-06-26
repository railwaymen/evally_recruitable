# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ShowView < Blueprinter::Base
      fields :positions, :groups, :sources

      field :recruit_document, default: {} do |presenter, options|
        next if presenter.recruit_document.blank?

        V2::RecruitDocuments::Serializer.render_as_hash(presenter.recruit_document, **options)
      end

      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []

      association :attachments, blueprint: V2::Attachments::Serializer, default: []
    end
  end
end
