# frozen_string_literal: true

FactoryBot.define do
  factory :change do
    factory :recruit_document_evaluator_change do
      context         { 'evaluator' }
      from            { nil }
      to              { '' }
      details         { {} }

      changeable      { FactoryBot.create(:recruit_document) }
      user
    end

    factory :recruit_document_status_change do
      context         { 'status' }
      from            { 'received' }
      to              { 'verified' }
      details         { {} }

      changeable      { FactoryBot.create(:recruit_document) }
      user
    end
  end
end
