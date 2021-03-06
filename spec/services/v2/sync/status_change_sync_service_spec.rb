# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Sync::StatusChangeSyncService do
  describe '.perform' do
    it 'expects to make a post request' do
      user = FactoryBot.create(:user, role: :admin)

      document = FactoryBot.create(
        :recruit_document,
        status: 'phone_call',
        call_scheduled_at: '2020-06-01 12:00:00'
      )

      status_change = FactoryBot.create(
        :recruit_document_status_change,
        changeable: document,
        to: 'phone_call',
        details: {
          call_scheduled_at: document.call_scheduled_at
        }
      )

      service = described_class.new(status_change, user)

      stub_request(:post, "http://testhost/v2/recruits/#{document.public_recruit_id}/comments/webhook") # rubocop:disable Layout/LineLength
        .with(
          body: {
            comment: {
              body: service.send(:comment_body),
              created_at: status_change.created_at.to_s,
              change_id: status_change.id,
              recruit_document_id: document.id
            }
          },
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'Token' => JwtService.encode(user),
            'User-Agent' => 'Faraday v0.17.3'
          }
        )
        .to_return(status: 204, body: '', headers: {})

      service.perform
    end
  end
end
