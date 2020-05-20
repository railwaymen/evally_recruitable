# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::SourcesMonthlyChartQuery do
  it 'returns proper daily calcs for recruitments by sources' do
    FactoryBot.create(
      :recruit_document,
      source: 'Website',
      received_at: '2020-05-17'
    )

    FactoryBot.create(
      :recruit_document,
      source: 'Website',
      received_at: '2020-05-18'
    )

    FactoryBot.create_list(
      :recruit_document,
      2,
      source: 'JobPortal',
      received_at: '2020-05-18'
    )

    FactoryBot.create(
      :recruit_document,
      source: 'JobPortal',
      received_at: '2020-05-19'
    )

    query = described_class.new('2020-05-01')

    expect(query.call).to include(
      { 'label' => '2020-05-17', 'source' => 'Website', 'value' => 1 },
      { 'label' => '2020-05-18', 'source' => 'JobPortal', 'value' => 2 },
      { 'label' => '2020-05-19', 'source' => 'JobPortal', 'value' => 1 },
      { 'label' => '2020-05-18', 'source' => 'Website', 'value' => 1 }
    )
  end
end
