# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def evaluator_assignment
    NotificationMailer
      .with(user: User.first, recruit_document: RecruitDocument.last)
      .evaluator_assignment
  end

  def status_change
    NotificationMailer
      .with(user: User.first, status_change: Change.find_by(context: 'status'))
      .status_change
  end
end
