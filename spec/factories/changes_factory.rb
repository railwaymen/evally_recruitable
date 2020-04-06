# frozen_string_literal: true

FactoryBot.define do
  factory :change do
    factory :recruit_document_status_change do
      context         { 'status' }
      from            { 'received' }
      to              { 'verified' }
      details         { {} }

      changeable      { FactoryBot.create(:recruit_document) }
    end
  end
end
