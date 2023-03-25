Rails.application.routes.draw do
  resources :entries, shallow: true do
    collection do
      get 'draft', action: :drafts
      get 'page/:page', action: :index
    end
    resources :pictures, only: [:index]
  end
  # resources :users
  resources :people do
    get 'page/:page', action: :index, on: :collection
  end
  # resources :pictures
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'pages#home'

  get 'sign_in',                    to: 'session#new',                as: 'user_sign_in'
  post 'sign_in',                   to: 'session#create',             as: 'user_session_create'
  delete 'sign_out',                to: 'session#delete',             as: 'user_sign_out'


  post 'people/search',              to: 'people#search',              as: 'search_people'




end
