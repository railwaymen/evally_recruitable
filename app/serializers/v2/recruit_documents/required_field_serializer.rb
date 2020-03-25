# frozen_string_literal: true

module V2
  module RecruitDocuments
    class RequiredFieldSerializer < Blueprinter::Base
      fields :value, :type, :label
    end
  end
end
