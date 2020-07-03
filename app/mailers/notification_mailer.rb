# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  add_template_helper VueRoutesHelper

  def evaluator_assignment
    @presenter = V2::Notifications::EvaluatorAssignmentPresenter.new(recruit_document, user)

    mail(to: recipient.mail_to, subject: @presenter.mail_subject)
  end

  def status_change
    @presenter = V2::Notifications::StatusChangePresenter.new(change, user)

    mail(to: recipient.mail_to, subject: @presenter.mail_subject)
  end

  private

  def recruit_document
    @recruit_document ||= params[:recruit_document]
  end

  def change
    @change ||= params[:change]
  end

  def recipient
    @recipient ||= params[:recipient]
  end

  def user
    @user ||= params[:user]
  end
end
