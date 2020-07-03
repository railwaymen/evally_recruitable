# frozen_string_literal: true

module V2
  module RecruitDocuments
    class StatusSerializer < Blueprinter::Base
      fields :value, :label, :disabled, :color, :group

      association :required_fields, blueprint: V2::RecruitDocuments::RequiredFieldSerializer,
                                    default: []
    end
  end
end
