# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module V2
  module RecruitDocuments
    class StatusManagerService
      Status = Struct.new(:value, :color, :group, :disabled, :required_fields, :notifiees) do
        def initialize(value:, color:, group:, disabled: false, required_fields: [], notifiees: []) # rubocop:disable Metrics/ParameterLists
          super(value, color, group, disabled, required_fields, notifiees)
        end

        def label
          value.to_s.titleize
        end

        def notify?(user_role)
          user_role.in? notifiees
        end
      end

      RequiredField = Struct.new(:value, :type) do
        def label
          value.to_s.titleize
        end
      end

      def self.statuses # rubocop:disable Metrics/AbcSize
        [
          ongoing_header, received, documents_review, incomplete_documents, verified, code_review,
          recruitment_task,phone_call, office_interview, evaluation, on_hold, supervisor_decision,
          completed_header, send_feedback, hired, consider_in_future, rejected, black_list
        ]
      end

      def self.enabled_statuses
        statuses.reject(&:disabled)
      end

      def self.enum
        enabled_statuses.collect { |status| [status.value, status.value.to_s] }.to_h
      end

      def self.find(value)
        enabled_statuses.find { |status| status.value == value.to_sym }
      end

      def self.ongoing_statuses
        enabled_statuses.select { |status| status.group == 'ongoing' }
      end

      def self.completed_statuses
        enabled_statuses.select { |status| status.group == 'completed' }
      end

      def self.ongoing_header
        Status.new(
          value: :ongoing,
          color: '#FFF',
          group: 'headers',
          disabled: true
        )
      end

      def self.received
        Status.new(
          value: :received,
          color: '#00838F',
          group: 'ongoing'
        )
      end

      def self.documents_review
        Status.new(
          value: :documents_review,
          color: '#5C6BC0',
          group: 'ongoing'
        )
      end

      def self.incomplete_documents
        Status.new(
          value: :incomplete_documents,
          color: '#FFCA28',
          group: 'ongoing',
          required_fields: [
            RequiredField.new(:incomplete_details, :text)
          ]
        )
      end

      def self.verified
        Status.new(
          value: :verified,
          color: '#AB47BC',
          group: 'ongoing'
        )
      end

      def self.code_review
        Status.new(
          value: :code_review,
          color: '#26A69A',
          group: 'ongoing',
          notifiees: %w[admin recruiter evaluator]
        )
      end

      def self.recruitment_task
        Status.new(
          value: :recruitment_task,
          color: '#4527A0',
          group: 'ongoing',
          notifiees: %w[admin recruiter evaluator],
          required_fields: [
            RequiredField.new(:task_sent_at, :datetime)
          ]
        )
      end

      def self.phone_call
        Status.new(
          value: :phone_call,
          color: '#AD1457',
          group: 'ongoing',
          notifiees: %w[admin recruiter evaluator],
          required_fields: [
            RequiredField.new(:call_scheduled_at, :datetime)
          ]
        )
      end

      def self.office_interview
        Status.new(
          value: :office_interview,
          color: '#29B6F6',
          group: 'ongoing',
          notifiees: %w[admin recruiter evaluator],
          required_fields: [
            RequiredField.new(:interview_scheduled_at, :datetime)
          ]
        )
      end

      def self.evaluation
        Status.new(
          value: :evaluation,
          color: '#FF7043',
          group: 'ongoing',
          notifiees: %w[admin recruiter evaluator]
        )
      end

      def self.on_hold
        Status.new(
          value: :on_hold,
          color: '#1565C0',
          group: 'ongoing'
        )
      end

      def self.supervisor_decision
        Status.new(
          value: :supervisor_decision,
          color: '#78909C',
          group: 'ongoing',
          notifiees: %w[admin recruiter]
        )
      end

      def self.completed_header
        Status.new(
          value: :completed,
          color: '#FFF',
          group: 'headers',
          disabled: true
        )
      end

      def self.send_feedback
        Status.new(
          value: :send_feedback,
          color: '#D4E157',
          group: 'completed'
        )
      end

      def self.hired
        Status.new(
          value: :hired,
          color: '#66BB6A',
          group: 'completed'
        )
      end

      def self.consider_in_future
        Status.new(
          value: :consider_in_future,
          color: '#FF8F00',
          group: 'completed'
        )
      end

      def self.rejected
        Status.new(
          value: :rejected,
          color: '#EF5350',
          group: 'completed',
          required_fields: [
            RequiredField.new(:rejection_reason, :text)
          ]
        )
      end

      def self.black_list
        Status.new(
          value: :black_list,
          color: '#000000',
          group: 'completed',
          required_fields: [
            RequiredField.new(:rejection_reason, :text)
          ]
        )
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
