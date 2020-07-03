# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def evaluator_assignment
    NotificationMailer
      .with(recipient: recipient, recruit_document: recruit_document, user: user)
      .evaluator_assignment
  end

  def status_change
    NotificationMailer
      .with(recipient: recipient, change: change, user: user)
      .status_change
  end

  private

  def change
    Change.find_by(context: 'status')
  end

  def recruit_document
    RecruitDocument.last
  end

  def recipient
    User.last
  end

  def user
    User.first
  end
end
