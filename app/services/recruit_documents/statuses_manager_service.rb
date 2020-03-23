# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength
module RecruitDocuments
  class StatusesManagerService
    RequiredField = Struct.new(:value, :type) do
      def label
        value.to_s.titleize
      end
    end

    Status = Struct.new(:value, :color, :required_fields) do
      def label
        value.to_s.titleize
      end
    end

    class << self
      def statuses # rubocop:disable Metrics/AbcSize
        [
          Status.new(
            :received,
            '#EF5350',
            []
          ),
          Status.new(
            :verified,
            '#AB47BC',
            []
          ),
          Status.new(
            :documents_review,
            '#5C6BC0',
            []
          ),
          Status.new(
            :incomplete_documents,
            '#29B6F6',
            []
          ),
          Status.new(
            :code_review,
            '#26A69A',
            []
          ),
          Status.new(
            :recruitment_task,
            '#66BB6A',
            [
              RequiredField.new(:task_sent_at, :datetime)
            ]
          ),
          Status.new(
            :phone_call,
            '#D4E157',
            [
              RequiredField.new(:call_scheduled_at, :datetime)
            ]
          ),
          Status.new(
            :office_interview,
            '#FFCA28',
            [
              RequiredField.new(:interview_scheduled_at, :datetime)
            ]
          ),
          Status.new(
            :evaluation,
            '#FF7043',
            []
          ),
          Status.new(
            :supervisor_decision,
            '#78909C',
            []
          ),
          Status.new(
            :awaiting_response,
            '#AD1457',
            [
              RequiredField.new(:decision_made_at, :datetime)
            ]
          ),
          Status.new(
            :hired,
            '#4527A0',
            [
              RequiredField.new(:recruit_acceptance_at, :datetime)
            ]
          ),
          Status.new(
            :on_hold,
            '#1565C0',
            []
          ),
          Status.new(
            :rejected,
            '#00838F',
            [
              RequiredField.new(:decistion_made_at, :datetime),
              RequiredField.new(:rejection_reason, :string)
            ]
          ),
          Status.new(
            :black_list,
            '#2E7D32',
            [
              RequiredField.new(:rejection_reason, :string)
            ]
          )
        ]
      end

      def enum
        statuses.collect { |status| [status.value, status.value.to_s] }.to_h
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength
