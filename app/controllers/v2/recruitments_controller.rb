# frozen_string_literal: true

module V2
  class RecruitmentsController < ApplicationController
    def index
      presenter = V2::Recruitments::IndexPresenter.new(Recruitment.all)

      render(
        json: V2::Recruitments::IndexView.render(presenter),
        status: :ok
      )
    end

    def create
      create_form.save

      render(
        json: V2::Recruitments::Serializer.render(create_form.recruitment),
        status: :created
      )
    end

    def update
      update_form.save

      render(
        json: V2::Recruitments::Serializer.render(update_form.recruitment),
        status: :ok
      )
    end

    def start
      response_status = recruitment.start! ? :ok : :unprocessable_entity

      render json: V2::Recruitments::Serializer.render(recruitment), status: response_status
    end

    def complete
      response_status = recruitment.complete! ? :ok : :unprocessable_entity

      render json: V2::Recruitments::Serializer.render(recruitment), status: response_status
    end

    def add_stage
      add_stage_form.save

      render(
        json: V2::Recruitments::Serializer.render(add_stage_form.recruitment),
        status: :ok
      )
    end

    def drop_stage
      drop_stage_form.save

      render(
        json: V2::Recruitments::Serializer.render(drop_stage_form.recruitment),
        status: :ok
      )
    end

    def destroy
      recruitment.destroy

      head :no_content
    end

    private

    def recruitment
      @recruitment ||= Recruitment.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruitment

      @recruitment
    end

    def create_form
      @create_form ||=
        V2::Recruitments::BasicForm.new(Recruitment.new, params: create_recruitment_params)
    end

    def update_form
      @update_form ||=
        V2::Recruitments::BasicForm.new(recruitment, params: update_recruitment_params)
    end

    def add_stage_form
      @add_stage_form ||=
        V2::Recruitments::AddStageForm.new(recruitment, stage: params[:stage])
    end

    def drop_stage_form
      @drop_stage_form ||=
        V2::Recruitments::DropStageForm.new(recruitment, stage: params[:stage])
    end

    def create_recruitment_params
      params.require(:recruitment).permit(:name, :description, user_tokens: [])
    end

    def update_recruitment_params
      params.require(:recruitment).permit(:name, :description, stages: [], user_tokens: [])
    end
  end
end
