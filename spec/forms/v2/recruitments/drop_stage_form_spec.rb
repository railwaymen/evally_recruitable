# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Recruitments::DropStageForm do
  describe 'valid?' do
    it 'is true' do
      recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])
      form = described_class.new(recruitment, stage: 'interview')

      expect(form).to be_valid
    end

    it 'adds existing assignments error' do
      recruitment = FactoryBot.create(:recruitment, stages: %w[call interview])
      FactoryBot.create(:recruitment_candidate, recruitment: recruitment, stage: 'call')

      form = described_class.new(recruitment, stage: 'call')

      expect(form).not_to be_valid
      expect(form.recruitment.errors.messages[:base].first).to eq 'Stage has assigned recruits'
    end
  end
end
