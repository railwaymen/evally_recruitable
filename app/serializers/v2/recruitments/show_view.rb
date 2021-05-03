# frozen_string_literal: true

module V2
  module Recruitments
    class ShowView < Blueprinter::Base
      association :recruitment, blueprint: V2::Recruitments::Serializer, default: {}

      field :candidates do |presenter|
        presenter.candidates.group_by(&:stage).transform_values do |values|
          V2::RecruitmentCandidates::Serializer.render_as_hash(values)
        end
      end
    end
  end
end
