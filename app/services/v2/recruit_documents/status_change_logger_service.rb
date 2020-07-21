# frozen_string_literal: true

module V2
  module RecruitDocuments
    class StatusChangeLoggerService
      attr_reader :recruit_document

      delegate :evaluator, to: :recruit_document

      def initialize(recruit_document, user)
        @recruit_document = recruit_document
        @user = user
      end

      def call
        return unless status_change_commentable

        status_change.save!
      end

      def notify
        return unless status_change_commentable && status_change.present?

        User.active.where(id: involved_users_ids).map do |recipient|
          next unless current_status.notify?(recipient.role)

          NotificationMailer
            .with(change: status_change, recipient: recipient, user: @user)
            .status_change
            .deliver_later
        end
      end

      def sync
        return unless status_change.persisted?

        V2::Sync::StatusChangesJob.perform_later(status_change.id, @user.id)
      end

      private

      def status_change_commentable
        @status_change_commentable ||= @recruit_document.status_change_commentable?
      end

      def status_change
        @status_change ||= @recruit_document.status_changes.build(
          user_token: @user.email_token,
          from: @recruit_document.status_was,
          to: @recruit_document.status,
          details: resolve_details
        )
      end

      def current_status
        @current_status ||=
          V2::RecruitDocuments::StatusManagerService.find(@recruit_document.status)
      end

      def resolve_details
        return {} if current_status.blank?

        @recruit_document.attributes.slice(
          *current_status.required_fields.collect { |field| field.value.to_s }
        )
      end

      def involved_users_ids
        [evaluator&.id, *User.recruiter.ids].compact.uniq - [@user.id]
      end
    end
  end
end
