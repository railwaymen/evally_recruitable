# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Sync::EvaluatorChangeSyncService do
  describe '.perform' do
    it 'expects to make a post request' do
      document = FactoryBot.create(:recruit_document)
      evaluator = FactoryBot.create(:user, role: :evaluator)
      user = FactoryBot.create(:user, role: :admin)

      evaluator_change = FactoryBot.create(
        :recruit_document_evaluator_change,
        changeable: document,
        to: evaluator.email_token
      )

      service = described_class.new(evaluator_change, user)

      stub_request(:post, "http://testhost/v2/recruits/#{document.public_recruit_id}/comments/webhook") # rubocop:disable Layout/LineLength
        .with(
          body: {
            comment: {
              body: service.send(:comment_body),
              created_at: evaluator_change.created_at.to_s,
              change_id: evaluator_change.id,
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
