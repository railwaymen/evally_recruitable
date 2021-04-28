# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :inbound_emails, only: :index

      resources :recruit_documents do
        collection do
          get :form
          get :search
          get :overview
        end

        member do
          get :mailer
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

      resources :users, only: [] do
        collection do
          post :webhook
        end
      end
    end

    root 'welcome#index'
  end
end
