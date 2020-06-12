# frozen_string_literal: true

FactoryBot.define do
  factory :recruit_document do
    first_name                  { 'Frank' }
    last_name                   { 'Sinatra' }
    gender                      { 'male' }
    sequence(:email)            { |n| "recruit#{n}@example.com" }
    phone                       { '111-222-333' }
    position                    { 'Ruby Developer' }
    group                       { 'Ruby' }
    accept_current_processing   { true }
    accept_future_processing    { false }
    source                      { 'railwaymen' }
    received_at                 { 1.minute.ago }
    status                      { 'received' }
    evaluator_id                { nil }
    social_links                { ['http://github.com/railwaymen'] }
    salary                      { '$1000' }
    availability                { 'full time' }
    available_since             { Date.current.next_month.beginning_of_month }
    location                    { 'Kraków' }
    contract_type               { 'B2B' }
    work_type                   { 'remotely' }
    message                     { 'Lorem ipsum dolor sit amet...' }

    trait :with_attachment do
      after(:create) do |document|
        document.files.attach(
          io: File.open('spec/fixtures/sample_resume.pdf'),
          filename: 'sample.pdf'
        )
      end
    end
  end
end
