# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  add_template_helper VueRoutesHelper

  def evaluator_assignment
    @presenter = V2::Notifications::EvaluatorAssignmentPresenter.new(recruit_document)

    mail(to: user.mail_to, subject: 'Evaluator Assignment News')
  end

  def status_change
    @presenter = V2::Notifications::StatusChangePresenter.new(change)

    mail(to: user.mail_to, subject: 'Status Change News')
  end

  private

  def recruit_document
    @recruit_document ||= params[:recruit_document]
  end

  def change
    @change ||= params[:status_change]
  end

  def user
    @user ||= params[:user]
  end
end
