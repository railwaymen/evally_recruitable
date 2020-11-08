# frozen_string_literal: true

module V2
  class RecruitDocumentsController < ApplicationController
    before_action :authorize_collection!, only: %i[index form mailer create search overview destroy]
    before_action :authorize_member!, only: %i[show update]

    def index
      presenter =
        V2::RecruitDocuments::IndexPresenter.new(recruit_documents_scope, params: filter_params)

      render(
        json: V2::RecruitDocuments::IndexView.render(presenter, user: current_user),
        status: :ok
      )
    end

    def show
      presenter = V2::RecruitDocuments::ShowPresenter.new(recruit_document)

      render(
        json: V2::RecruitDocuments::ShowView.render(presenter, user: current_user),
        status: :ok
      )
    end

    def form
      presenter = V2::RecruitDocuments::ShowPresenter.new

      render(
        json: V2::RecruitDocuments::ShowView.render(presenter, user: current_user),
        status: :ok
      )
    end

    def mailer
      render json: V2::RecruitDocuments::Serializer.render(recruit_document, user: current_user)
    end

    def create
      create_form.save

      render(
        json: V2::RecruitDocuments::Serializer.render(
          create_form.recruit_document, user: current_user
        ),
        status: :created
      )
    end

    def update
      update_form.save

      render(
        json: V2::RecruitDocuments::Serializer.render(
          update_form.recruit_document, user: current_user
        ),
        status: :ok
      )
    end

    def destroy
      ActiveRecord::Base.transaction do
        inbound_email.destroy if inbound_email.present?
        recruit_document.destroy
      end

      head :no_content
    end

    def search
      recruit_documents =
        V2::RecruitDocuments::SearchQuery.new(recruit_documents_scope, params: params).call

      render(
        json: V2::RecruitDocuments::SearchView.render(recruit_documents),
        status: :ok
      )
    end

    def overview
      presenter = V2::RecruitDocuments::OverviewPresenter.new(params[:date])

      render(
        json: V2::RecruitDocuments::OverviewView.render(presenter),
        status: :ok
      )
    end

    private

    def authorize_collection!
      authorize([:v2, RecruitDocument])
    end

    def authorize_member!
      authorize([:v2, recruit_document])
    end

    def recruit_documents_scope
      policy_scope([:v2, RecruitDocument]).order(received_at: :desc)
    end

    def recruit_document
      @recruit_document ||= RecruitDocument.find_by(id: params[:id])
      raise ErrorResponderService.new(:record_not_found, 404) unless @recruit_document

      @recruit_document
    end

    def inbound_email
      @inbound_email ||=
        ActionMailbox::InboundEmail.find_by(message_id: recruit_document.message_id)
    end

    def create_form
      @create_form ||= V2::RecruitDocuments::BasicForm.new(
        RecruitDocument.new,
        params: recruit_document_params,
        user: current_user
      )
    end

    def update_form
      @update_form ||= V2::RecruitDocuments::BasicForm.new(
        recruit_document,
        params: recruit_document_params,
        user: current_user
      )
    end

    def filter_params
      params.permit(:group, :status, :evaluator_token)
    end

    def recruit_document_params
      params.require(:recruit_document).permit(
        :first_name, :last_name, :gender, :email, :phone, :position, :group, :received_at, :source,
        :accept_current_processing, :accept_future_processing, :task_sent_at, :call_scheduled_at,
        :interview_scheduled_at, :incomplete_details, :rejection_reason, :evaluator_token,
        :social_links, :salary, :availability, :available_since, :location, :contract_type,
        :work_type, :message, status: :value, files: []
      )
    end
  end
end
