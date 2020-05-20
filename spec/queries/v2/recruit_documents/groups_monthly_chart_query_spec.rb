# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::GroupsMonthlyChartQuery do
  it 'returns proper daily calcs for recruitments by groups' do
    FactoryBot.create(
      :recruit_document,
      group: 'Ruby',
      received_at: '2020-05-10'
    )

    FactoryBot.create(
      :recruit_document,
      group: 'Ruby',
      received_at: '2020-05-13'
    )

    FactoryBot.create_list(
      :recruit_document,
      2,
      group: 'iOS',
      received_at: '2020-05-10'
    )

    FactoryBot.create(
      :recruit_document,
      group: 'iOS',
      received_at: '2020-05-11'
    )

    query = described_class.new('2020-05-01')

    expect(query.call).to include(
      { 'label' => '2020-05-10', 'group' => 'Ruby', 'value' => 1 },
      { 'label' => '2020-05-10', 'group' => 'iOS', 'value' => 2 },
      { 'label' => '2020-05-11', 'group' => 'iOS', 'value' => 1 },
      { 'label' => '2020-05-13', 'group' => 'Ruby', 'value' => 1 }
    )
  end
end
