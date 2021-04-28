# frozen_string_literal: true

FactoryBot.define do
  factory :recruitment_candidate do
    association :recruit_document
    association :recruitment

    stage { 'call' }
  end
end
