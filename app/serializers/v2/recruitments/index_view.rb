# frozen_string_literal: true

module V2
  module Recruitments
    class IndexView < Blueprinter::Base
      association :recruitments, blueprint: V2::Recruitments::Serializer, default: []
      association :users, blueprint: V2::Users::Serializer, default: []

      field :candidates_tree do |presenter|
        presenter.candidates.group_by(&:recruitment_id).transform_values do |v1|
          v1.group_by(&:stage).transform_values do |v2|
            V2::RecruitmentCandidates::Serializer.render_as_hash(v2)
          end
        end
      end
    end
  end
end
