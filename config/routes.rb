Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  resources :entries, shallow: true, concerns: :paginatable do
    collection do
      get 'published',            action: :index
      get ':status/page/:page',   action: :index
    end
    resources :pictures, only: [:index, :create]
  end
  resources :users, except: :index
  resources :people do
    collection do
      get "search"
      get "search/page/:page",  action: :search
      get 'page/:page',         action: :index
    end
    resources :notes, only: [:create]
    member do
      get 'edit'
      get ':tab',               action: :show, as: :tab
      get ':tab/page/:page',    action: :show
    end
  end
  resources :notes, only: [:destroy]
  resources :pictures, only: [:show, :update]
  # Define your application asroutes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'pages#home'

  get 'sign_in',                    to: 'session#new'
  post 'sign_in',                   to: 'session#create'
  delete 'sign_out',                to: 'session#delete'
end
