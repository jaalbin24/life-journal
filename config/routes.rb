Rails.application.routes.draw do
  resources :entries
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'pages#home'

  get 'sign_in',                    to: 'session#new',                as: 'user_sign_in'
  post 'sign_in',                   to: 'session#create',             as: 'user_session_create'
  delete 'sign_out',                to: 'session#delete',             as: 'user_sign_out'




end
