# frozen_string_literal: true

module V2
  module RecruitDocuments
    class BasicForm
      attr_reader :recruit_document

      def initialize(recruit_document, params:, user:)
        @recruit_document = recruit_document
        @user = user

        @recruit_document.assign_attributes(
          status: params.dig('status', 'value') || recruit_document.status,
          **params.except('status')
        )
      end

      def save
        validate_recruit_document!

        ActiveRecord::Base.transaction do
          assign_evaluator_to_other_recruit_documents
          @recruit_document.save!

          synchronize_recruit
        end
      end

      private

      def validate_recruit_document!
        return if @recruit_document.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruit_document.errors.full_messages
        )
      end

      def assign_evaluator_to_other_recruit_documents
        return if @recruit_document.persisted? && !@recruit_document.evaluator_id_changed?

        RecruitDocument
          .where('email = ?', @recruit_document.email)
          .update_all(evaluator_id: @recruit_document.evaluator_id)
      end

      def synchronize_recruit
        resp = core_api_client.post(
          '/v2/recruits/webhook',
          recruit: {
            public_recruit_id: @recruit_document.public_recruit_id,
            evaluator_id: @recruit_document.evaluator_id
          }
        )

        Rails.logger.debug(
          "\e[35mRecruit Sync  |  #{resp.status}  |  #{@recruit_document.public_recruit_id}\e[0m"
        )
      end

      def core_api_client
        @core_api_client ||= ApiClientService.new(
          @user, Rails.application.config.env.fetch(:core_host)
        )
      end
    end
  end
end
