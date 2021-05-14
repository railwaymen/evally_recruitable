# frozen_string_literal: true

module V2
  class RecruitmentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return scope.all if user.admin? || user.recruiter?

        user.recruitments.started
      end
    end

    def index?
      true
    end

    def create?
      admin_or_recruiter?
    end

    def update?
      admin_or_recruiter?
    end

    def start?
      admin_or_recruiter?
    end

    def complete?
      admin_or_recruiter?
    end

    def add_stage?
      admin_or_recruiter?
    end

    def drop_stage?
      admin_or_recruiter?
    end

    def destroy?
      admin_or_recruiter?
    end

    private

    def admin_or_recruiter?
      user.admin? || user.recruiter?
    end
  end
end
