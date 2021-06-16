# frozen_string_literal: true

require 'classifier-reborn'

module RecruitDocuments
  class GroupClassifierService
    delegate :reset, to: :classifier

    def train
      grouped_documents.pluck(:group, :position).each do |data|
        classifier.train(data.first.to_sym, data.last)
      end
    end

    def classify(recruit_document)
      return if Rails.env.test? || recruit_document&.position.blank?

      result = classifier.classify(recruit_document.position).presence || 'Unknown'
      recruit_document.update(group: result)
    end

    private

    def classifier
      @classifier ||=
        ClassifierReborn::Bayes.new(
          *grouped_documents.pluck(:group).uniq.map(&:to_sym),
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

    def grouped_documents
      RecruitDocument.where.not(group: 'Unknown')
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
