# frozen_string_literal: true

module V2
  class RecruitGuard
    def self.authorize?(user, public_recruit_id:) # rubocop:disable Metrics/MethodLength
      return true if user.admin? || user.recruiter?

      Recruitment
        .not_completed
        .joins(
          recruitment_participants: :user,
          recruitment_candidates: :recruit_document
        )
        .where(
          users: { id: user.id },
          recruit_documents: { public_recruit_id: public_recruit_id }
        )
        .exists?
    end
  end
end
