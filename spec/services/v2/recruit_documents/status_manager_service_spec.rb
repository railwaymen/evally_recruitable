# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::RecruitDocuments::StatusManagerService do
  describe 'status struct' do
    context 'notify?' do
      it 'expects to be false if no notifiees' do
        received_status = described_class.received

        expect(received_status.notify?('admin')).to eq false
      end

      it 'expects to be true if notifiees exist' do
        phone_call_status = described_class.phone_call

        expect(phone_call_status.notify?('admin')).to eq true
        expect(phone_call_status.notify?('recruiter')).to eq true
        expect(phone_call_status.notify?('evaluator')).to eq true
      end
    end
  end

  describe '.statuses' do
    it 'expects to return 16 statuses' do
      expect(described_class.enabled_statuses.count).to eq 16
    end
  end

  describe '.ongoing_statuses' do
    it 'expects to return list with statuses where group is ongoing' do
      expect(described_class.ongoing_statuses.map(&:value)).to contain_exactly(
        :received, :documents_review, :incomplete_documents, :verified, :code_review,
        :recruitment_task, :phone_call, :office_interview, :evaluation, :on_hold,
        :supervisor_decision
      )
    end
  end

  describe '.completed_statuses' do
    it 'expects to return list with statuses where group is completed' do
      expect(described_class.completed_statuses.map(&:value)).to contain_exactly(
        :send_feedback, :hired, :consider_in_future, :rejected, :black_list
      )
    end
  end

  describe '.find' do
    it 'expects to find status' do
      status = described_class.find(:received)

      expect(status).to have_attributes(
        value: :received,
        required_fields: [],
        group: 'ongoing',
        disabled: false
      )
    end

    it 'expects to return nil' do
      status = described_class.find(:unknown)

      expect(status).to be_nil
    end
  end
end
