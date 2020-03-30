# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :recruit_documents do
        collection do
          get :form
        end

        resources :attachments, only: %i[create destroy]
      end
    end

    root 'welcome#index'
  end
end
