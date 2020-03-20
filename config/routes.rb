# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pl/ do
    root 'welcome#index'
  end
end
