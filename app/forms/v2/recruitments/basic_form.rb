# frozen_string_literal: true

module V2
  module Recruitments
    class BasicForm
      attr_reader :recruitment

      def initialize(recruitment, params:)
        @recruitment = recruitment
        @user_tokens = params.fetch('user_tokens', [])

        @recruitment.assign_attributes(
          user_ids: User.where(email_token: @user_tokens).ids,
          **params.except('user_tokens')
        )
      end

      def save
        validate_recruitment!

        @recruitment.save
      end

      private

      def validate_recruitment!
        return if @recruitment.valid?

        raise ErrorResponderService.new(
          :invalid_record, 422, @recruitment.errors.full_messages
        )
      end
    end
  end
end
