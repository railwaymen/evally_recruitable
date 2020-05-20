# frozen_string_literal: true

module V2
  class RecruitDocumentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return scope.all if user.admin? || user.recruiter?

        scope.where(evaluator_id: user.id)
      end
    end

    def index?
      true
    end

    def show?
      true
    end

    def create?
      user.admin? || user.recruiter?
    end

    def form?
      create?
    end

    def update?
      true
    end

    def destroy?
      create?
    end

    def search?
      true
    end

    def overview?
      create?
    end
  end
end
