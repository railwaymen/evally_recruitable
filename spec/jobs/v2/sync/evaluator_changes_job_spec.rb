# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Sync::EvaluatorChangesJob, type: :job do
  describe '#perform' do
    it 'expects to call user sync service' do
      admin = FactoryBot.create(:user, role: :admin)

      document = FactoryBot.create(:recruit_document)
      change = FactoryBot.create(:recruit_document_evaluator_change, changeable: document)

      job = described_class.new

      allow_any_instance_of(V2::Sync::EvaluatorChangeSyncService).to receive(:perform)
      stub_api_client_service

      job.perform(change.id, admin.id)
    end
  end
end
