# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::ReportableMonthsQuery do
  it 'returns proper months for recruitments reports' do
    FactoryBot.create(:recruit_document, received_at: '2020-03-31')
    FactoryBot.create(:recruit_document, received_at: '2020-06-01')

    expect(described_class.call).to include(
      { 'month' => '2020-03-01' },
      { 'month' => '2020-04-01' },
      { 'month' => '2020-05-01' },
      { 'month' => '2020-06-01' }
    )
  end
end
