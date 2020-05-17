# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :recruit_documents do
        collection do
          get :form
          get :search
        end

        resources :attachments, only: %i[create destroy]
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
