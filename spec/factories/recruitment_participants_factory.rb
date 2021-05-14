# frozen_string_literal: true

FactoryBot.define do
  factory :recruitment_participant do
    association :user
    association :recruitment
  end
end
