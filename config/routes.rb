# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :inbound_emails, only: :index

      resources :policies, only: [] do
        collection do
          get :recruit
        end
      end

      resources :recruit_documents do
        collection do
          get :form
          get :search
          get :overview
        end

        member do
          get :mailer
          post :assign
        end

        resources :attachments, only: %i[create destroy]
      end

      resources :recruitments do
        member do
          put :start
          put :complete
          put :add_stage
          put :drop_stage
        end
      end

      resources :recruitment_candidates, only: %i[update destroy] do
        member do
          put :move
        end
      end

      resources :users, only: [] do
        collection do
          post :webhook
        end
      end
    end

    root 'welcome#index'
  end
end
