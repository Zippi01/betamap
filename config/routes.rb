Rails.application.routes.draw do
  
  resources :places
  # scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }

  resources :parser_sites

  root 'home_pages#index'
end
