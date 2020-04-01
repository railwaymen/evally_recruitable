# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength
module V2
  module RecruitDocuments
    class StatusManagerService
      RequiredField = Struct.new(:value, :type) do
        def label
          value.to_s.titleize
        end
      end

      Status = Struct.new(:value, :color, :disabled, :required_fields) do
        def label
          value.to_s.titleize
        end
      end

      class << self
        def statuses # rubocop:disable Metrics/AbcSize
          [
            Status.new(:recruitment_in_progress, '#FFFFFF', true, []),
            Status.new(
              :received,
              '#00838F',
              false,
              []
            ),
            Status.new(
              :documents_review,
              '#5C6BC0',
              false,
              []
            ),
            Status.new(
              :incomplete_documents,
              '#FFCA28',
              false,
              []
            ),
            Status.new(
              :code_review,
              '#26A69A',
              false,
              []
            ),
            Status.new(
              :verified,
              '#AB47BC',
              false,
              []
            ),
            Status.new(
              :recruitment_task,
              '#4527A0',
              false,
              [
                RequiredField.new(:task_sent_at, :datetime)
              ]
            ),
            Status.new(
              :phone_call,
              '#AD1457',
              false,
              [
                RequiredField.new(:call_scheduled_at, :datetime)
              ]
            ),
            Status.new(
              :office_interview,
              '#29B6F6',
              false,
              [
                RequiredField.new(:interview_scheduled_at, :datetime)
              ]
            ),
            Status.new(
              :evaluation,
              '#FF7043',
              false,
              []
            ),
            Status.new(
              :supervisor_decision,
              '#78909C',
              false,
              []
            ),
            Status.new(:recruitment_completed, '#FFFFFF', true, []),
            Status.new(
              :awaiting_response,
              '#D4E157',
              false,
              [
                RequiredField.new(:decision_made_at, :datetime)
              ]
            ),
            Status.new(
              :hired,
              '#66BB6A',
              false,
              [
                RequiredField.new(:recruit_accepted_at, :datetime)
              ]
            ),
            Status.new(
              :on_hold,
              '#1565C0',
              false,
              []
            ),
            Status.new(
              :rejected,
              '#EF5350',
              false,
              [
                RequiredField.new(:decision_made_at, :datetime),
                RequiredField.new(:rejection_reason, :text)
              ]
            ),
            Status.new(
              :black_list,
              '#000000',
              false,
              [
                RequiredField.new(:rejection_reason, :text)
              ]
            )
          ]
        end

        def enum
          statuses
            .reject(&:disabled)
            .collect { |status| [status.value, status.value.to_s] }
            .to_h
        end

        def find(value)
          statuses.find { |status| status.value == value.to_sym }
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength
