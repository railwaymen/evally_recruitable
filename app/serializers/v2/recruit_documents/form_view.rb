# frozen_string_literal: true

module V2
  module RecruitDocuments
    class FormView < Blueprinter::Base
      association :statuses, blueprint: V2::RecruitDocuments::StatusSerializer, default: []

      fields :groups, :positions
    end
  end
end
