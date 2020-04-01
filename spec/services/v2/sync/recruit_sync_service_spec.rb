# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Sync::RecruitSyncService do
  describe '.perform' do
    it 'expects to make a post request' do
      document = FactoryBot.create(:recruit_document, evaluator_id: 1)
      user = User.new(id: 1, role: :admin)

      stub_request(:post, 'http://app.testhost/v2/recruits/webhook')
        .with(
          body: {
            recruit: {
              public_recruit_id: document.public_recruit_id,
              evaluator_id: document.evaluator_id
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

      described_class.new(document, user).perform
    end
  end
end
