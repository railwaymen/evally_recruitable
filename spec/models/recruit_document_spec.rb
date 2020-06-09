# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocument, type: :model do
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_presence_of(:first_name) }

  it { is_expected.to validate_presence_of(:position) }

  it { is_expected.to validate_presence_of(:group) }

  it { is_expected.to validate_presence_of(:received_at) }

  it { is_expected.to validate_presence_of(:accept_current_processing) }

  it { is_expected.to validate_presence_of(:status) }

  describe 'enums' do
    it do
      is_expected.to(
        define_enum_for(:status)
          .with_values(V2::RecruitDocuments::StatusManagerService.enum)
          .backed_by_column_of_type(:string)
          .with_suffix
      )
    end
  end

  describe 'required fields dependent on status' do
    context 'task_sent_at validation' do
      subject { FactoryBot.build(:recruit_document, status: :recruitment_task) }

      it { is_expected.to validate_presence_of(:task_sent_at) }
    end

    context 'call_scheduled_at validation' do
      subject { FactoryBot.build(:recruit_document, status: :phone_call) }

      it { is_expected.to validate_presence_of(:call_scheduled_at) }
    end

    context 'interview_scheduled_at validation' do
      subject { FactoryBot.build(:recruit_document, status: :office_interview) }

      it { is_expected.to validate_presence_of(:interview_scheduled_at) }
    end

    context 'incomplete_details validation' do
      subject { FactoryBot.build(:recruit_document, status: :incomplete_documents) }

      it { is_expected.to validate_presence_of(:incomplete_details) }
    end

    context 'rejection_reason validation' do
      subject { FactoryBot.build(:recruit_document, status: :rejected) }

      it { is_expected.to validate_presence_of(:rejection_reason) }

      subject { FactoryBot.build(:recruit_document, status: :black_list) }

      it { is_expected.to validate_presence_of(:rejection_reason) }
    end
  end
end
