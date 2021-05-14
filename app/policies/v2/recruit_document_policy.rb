# frozen_string_literal: true

module V2
  class RecruitDocumentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return scope.all if user.admin? || user.recruiter?

        scope
          .joins(recruitment_candidates: :recruitment)
          .where(recruitments: { id: user.recruitments.ids, status: :started })
      end
    end

    def index?
      true
    end

    def show?
      admin_or_recruiter? || started_recruitment_participant?
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
      admin_or_recruiter? || started_recruitment_participant?
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

    def started_recruitment_participant?
      (user.recruitments.started.ids & record.recruitments.started.ids).any?
    end
  end
end
