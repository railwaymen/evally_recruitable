# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    namespace :v2 do
      resources :recruit_documents, only: %i[index show create update] do
        collection do
          get :form
        end

        resources :recruit_document_files, path: 'files', only: %i[create destroy]
      end
    end

    root 'welcome#index'
  end
end
