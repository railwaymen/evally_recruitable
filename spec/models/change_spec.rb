# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Change, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:context) }

    it { is_expected.to validate_presence_of(:to) }
  end

  describe 'methods' do
    context '.comment_body' do
      it 'renders comment body properly with details' do
        status_change = FactoryBot.create(
          :recruit_document_status_change,
          from: :received,
          to: :phone_call,
          details: {
            call_scheduled_at: Time.zone.parse('2020-05-01 12:00:00')
          }
        )

        expect(status_change.comment_body).to match(
          %r{^<p>Status changed.+Received.+Phone Call.+<\/p>.+Call Scheduled At.+01 May 2020}
        )
      end
    end
  end
end
