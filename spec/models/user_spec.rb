# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it do
    is_expected.to(
      have_many(:recruit_document_changes)
        .conditions(changeable_type: 'RecruitDocument')
        .with_primary_key('email_token')
        .with_foreign_key('user_token')
        .class_name('Change')
    )
  end

  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_presence_of(:first_name) }

  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to validate_presence_of(:role) }

  it { is_expected.to validate_presence_of(:status) }

  describe 'mail_to' do
    it 'expects to be proper mail with label' do
      admin = FactoryBot.create(
        :user,
        role: :admin,
        first_name: 'Jack',
        last_name: 'Sparrow',
        email: 'jsparrow@example.com'
      )

      expect(admin.mail_to).to eq 'Jack Sparrow <jsparrow@example.com>'
    end
  end
end
