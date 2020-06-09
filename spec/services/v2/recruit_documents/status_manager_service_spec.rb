# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::StatusManagerService do
  describe '.statuses' do
    it 'expects to return 17 statuses' do
      expect(described_class.statuses.count).to eq 18
    end
  end

  describe '.find' do
    it 'expects to find status' do
      status = described_class.find(:received)

      expect(status).to have_attributes(
        value: :received,
        required_fields: [],
        disabled: false
      )
    end

    it 'expects to return nil' do
      status = described_class.find(:unknown)

      expect(status).to be_nil
    end
  end
end
