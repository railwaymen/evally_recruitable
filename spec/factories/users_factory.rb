# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email)    { |n| "user#{n}@example.com" }
    first_name          { 'Frank' }
    last_name           { 'Stevens' }
    role                { 'admin' }
    status              { 'active' }
    signature           { nil }
  end
end
