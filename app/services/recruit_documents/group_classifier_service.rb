# frozen_string_literal: true

require 'classifier-reborn'

module RecruitDocuments
  class GroupClassifierService
    def train
      RecruitDocument.where.not(group: 'Unknown').pluck(:group, :position).each do |training_set|
        classifier.train(*training_set)
      end
    end

    def classify(recruit_document)
      return if Rails.env.test? || recruit_document&.position.blank?

      recruit_document.update(
        group: classifier.classify(recruit_document.position).presence || 'Unknown'
      )
    end

    private

    def classifier
      @classifier ||=
        ClassifierReborn::Bayes.new(
          enable_threshold: true, threshold: -10, backend: redis_backend
        )
    end

    def redis_backend
      @redis_backend ||=
        ClassifierReborn::BayesRedisBackend.new(
          url: redis_envs.fetch(:url),
          namespace: Rails.env.development? ? basename : redis_envs.fetch(:namespace)
        )
    end

    # :nocov:
    def redis_envs
      @redis_envs ||= Rails.application.config.env.fetch(:recruitable).fetch(:redis)
    end

    def basename
      Rails.root.basename.to_s
    end
    # :nocov:
  end
end
