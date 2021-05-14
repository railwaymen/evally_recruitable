# frozen_string_literal: true

FactoryBot.define do
  factory :recruitment do
    name        { 'Sample recruitment' }
    description { 'Lorem ipsum ...' }
    stages      { %w[first seconds final] }

    trait :started do
      status      { 'started' }
      started_at  { 1.hour.ago }
    end

    trait :completed do
      status        { 'completed' }
      started_at    { 1.month.ago }
      completed_at  { 1.hour.ago }
    end
  end
end
