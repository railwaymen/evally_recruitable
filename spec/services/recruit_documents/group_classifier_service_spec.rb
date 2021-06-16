# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocuments::GroupClassifierService do
  describe 'train' do
    it 'expects to train ClassifierReborn::Bayes model' do
      FactoryBot.create(:recruit_document, group: 'Android', position: 'Junior Android Dev')
      FactoryBot.create(:recruit_document, group: 'iOS', position: 'iOS Dev')

      classifier    = instance_double ClassifierReborn::Bayes
      redis_backend = instance_double ClassifierReborn::BayesRedisBackend

      expect(ClassifierReborn::Bayes).to receive(:new).and_return(classifier)
      expect(ClassifierReborn::BayesRedisBackend).to receive(:new).and_return(redis_backend)

      expect(classifier).to receive(:train).twice

      described_class.new.train
    end
  end

  describe 'classify' do
    it 'expects to call classify on classifier model' do
      document = FactoryBot.create(:recruit_document, group: 'Unknown', position: 'iOS Dev')

      classifier    = instance_double ClassifierReborn::Bayes
      redis_backend = instance_double ClassifierReborn::BayesRedisBackend

      expect(ClassifierReborn::Bayes).to receive(:new).and_return(classifier)
      expect(ClassifierReborn::BayesRedisBackend).to receive(:new).and_return(redis_backend)

      expect(classifier).to receive(:classify).with(document.position)

      allow(Rails.env).to receive(:test?).and_return(false)

      described_class.new.classify(document)
    end
  end
end
