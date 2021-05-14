# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Recruitments::AddStageForm do
  describe 'valid?' do
    it 'is true' do
      recruitment = FactoryBot.create(:recruitment, stages: %w[call])
      form = described_class.new(recruitment, stage: 'interview')

      expect(form).to be_valid
    end

    it 'adds presence error' do
      recruitment = FactoryBot.create(:recruitment, stages: %w[call])
      form = described_class.new(recruitment, stage: 'call')

      expect(form).not_to be_valid
      expect(form.recruitment.errors.messages[:base].first).to eq 'Stage has already been taken'
    end

    it 'adds uniqueness error' do
      recruitment = FactoryBot.create(:recruitment, stages: %w[call])
      form = described_class.new(recruitment, stage: '')

      expect(form).not_to be_valid
      expect(form.recruitment.errors.messages[:base].first).to eq 'Stage can\'t be blank'
    end
  end
end
