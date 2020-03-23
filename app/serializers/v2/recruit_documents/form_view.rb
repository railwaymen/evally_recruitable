# frozen_string_literal: true

module V2
  module RecruitDocuments
    class FormView < Blueprinter::Base
      fields :groups, :positions, :statuses
    end
  end
end
