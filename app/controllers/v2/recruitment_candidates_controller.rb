# frozen_string_literal: true

module V2
  class RecruitmentCandidatesController < ApplicationController
    def move
      move_form.save

      presenter = V2::Recruitments::ShowPresenter.new(move_form.recruitment)

      render(
        json: V2::Recruitments::ShowView.render(presenter),
        status: :ok
      )
    end

    def update
      update_form.save

      presenter = V2::Recruitments::ShowPresenter.new(update_form.recruitment)

      render(
        json: V2::Recruitments::ShowView.render(presenter),
        status: :ok
      )
    end

    def destroy
      presenter = V2::Recruitments::ShowPresenter.new(candidate.recruitment)

      candidate.destroy

      render(
        json: V2::Recruitments::ShowView.render(presenter),
        status: :ok
      )
    end

    private

    def candidate
      @candidate ||= RecruitmentCandidate.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @candidate

      @candidate
    end

    def move_form
      @move_form ||=
        V2::RecruitmentCandidates::MoveForm.new(candidate, params: move_candidate_params)
    end

    def update_form
      @update_form ||=
        V2::RecruitmentCandidates::UpdateForm.new(candidate, params: update_candidate_params)
    end

    def move_candidate_params
      params.require(:candidate).permit(:stage, :position)
    end

    def update_candidate_params
      params.require(:candidate).permit(:priority)
    end
  end
end
