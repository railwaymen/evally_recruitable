# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :recruit_documents, only: %i[index show]
    end

    root 'welcome#index'
  end
end
