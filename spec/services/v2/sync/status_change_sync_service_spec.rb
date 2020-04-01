# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Sync::StatusChangeSyncService do
  describe '.perform' do
    it 'expects to make a post request' do
      document = FactoryBot.create(:recruit_document)
      status_change = FactoryBot.create(:recruit_document_status_change, changeable: document)
      user = User.new(id: 1, role: :admin)

      stub_request(:post, "http://app.testhost/v2/recruits/#{document.public_recruit_id}/comments/webhook") # rubocop:disable Layout/LineLength
        .with(
          body: {
            comment: {
              body: status_change.comment_body,
              created_at: status_change.created_at.to_s,
              change_id: status_change.id
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

      described_class.new(status_change, user).perform
    end
  end
end
