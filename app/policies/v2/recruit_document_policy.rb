# frozen_string_literal: true

module V2
  class RecruitDocumentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return scope.all if user.admin? || user.recruiter?

        scope.where(evaluator_token: user.email_token)
      end
    end

    def index?
      true
    end

    def show?
      admin_or_recruiter? || assigned_evaluator?
    end

    def create?
      admin_or_recruiter?
    end

    def form?
      admin_or_recruiter?
    end

    def mailer?
      admin_or_recruiter?
    end

    def update?
      admin_or_recruiter? || assigned_evaluator?
    end

    def destroy?
      admin_or_recruiter?
    end

    def search?
      true
    end

    def overview?
      admin_or_recruiter?
    end

    private

    def admin_or_recruiter?
      user.admin? || user.recruiter?
    end

    def assigned_evaluator?
      user.email_token == record.evaluator_token
    end
  end
end
