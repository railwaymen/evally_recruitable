# frozen_string_literal: true

FactoryBot.define do
  factory :recruit_document do
    first_name                  { 'Frank' }
    last_name                   { 'Sinatra' }
    gender                      { 'male' }
    sequence(:email)            { |n| "recruit#{n}@example.com" }
    phone                       { '111-222-333' }
    position                    { 'Ruby Developr' }
    group                       { 'Ruby' }
    accept_current_processing   { true }
    accept_future_processing    { false }
    source                      { 'railwaymen' }
    received_at                 { 1.minute.ago }
  end
end
