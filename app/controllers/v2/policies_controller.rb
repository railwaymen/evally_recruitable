# frozen_string_literal: true

module V2
  class PoliciesController < ApplicationController
    def recruit
      guard_result = V2::RecruitGuard.authorize?(
        current_user, public_recruit_id: params[:public_recruit_id]
      )

      head guard_result ? :no_content : :forbidden
    end
  end
end
