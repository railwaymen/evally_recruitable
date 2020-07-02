# frozen_string_literal: true

module V2
  module Notifications
    class StatusChangePresenter
      attr_reader :status_change, :user

      def initialize(status_change, user)
        @status_change = status_change
        @user = user
      end

      def recruit_document
        @recruit_document ||= @status_change.changeable
      end

      def previous_status
        @previous_status ||=
          V2::RecruitDocuments::StatusManagerService.find(@status_change.from)
      end

      def current_status
        @current_status ||=
          V2::RecruitDocuments::StatusManagerService.find(@status_change.to)
      end

      def format_status_detail(field)
        value = @status_change.details[field]

        return value.to_s unless value.is_a?(ActiveSupport::TimeWithZone)

        value.localtime.strftime('%d %b %Y, %H:%M %Z')
      end
    end
  end
end
