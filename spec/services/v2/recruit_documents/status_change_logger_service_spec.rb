# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::StatusChangeLoggerService do
  describe '.save' do
    it 'expects to save status change on update' do
      document = FactoryBot.create(:recruit_document, status: 'received')

      document.status = 'verified'
      service = described_class.new(document)

      expect do
        expect(service.save!).to eq true
      end.to(change { document.status_changes.count }.by(1))

      expect(document.status_changes.last).to have_attributes(
        from: 'received',
        to: 'verified',
        details: {}
      )
    end
  end
end
