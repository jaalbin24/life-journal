Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  resources :entries, shallow: true, concerns: :paginatable do
    collection do
      get "search"
      get "search/page/:page",    action: :search
      get ':tab',              action: :index, constraints: { tab: /(all|published|drafts|trash)/ }, as: :tab
      get ':tab/page/:page',   action: :index, constraints: { tab: /(all|published|drafts|trash)/ }
    end
    member do
      post 'recover'
    end
    resources :mentions, only: [:create, :new]
  end
  resources :users, except: :index
  resources :people, shallow: true, concerns: :paginatable do
    collection do
      get "search"
      get "search/page/:page",  action: :search
      get ':tab',               action: :index, constraints: { tab: /(all|trash)/ }, as: :tab
      get ':tab/page/:page',    action: :index, constraints: { tab: /(all|trash)/ }
    end
    resources :notes, only: [:create]
    member do
      get ':tab',               action: :show, constraints: { tab: /(biography|notes|mentions|info)/ }, as: :tab
      get ':tab/page/:page',    action: :show, constraints: { tab: /(biography|notes|mentions|info)/ }
    end
  end
  resources :mentions
  resources :notes, only: [:destroy]
  # Define your application asroutes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'pages#home'

  get 'sign_in',                    to: 'session#new'
  post 'sign_in',                   to: 'session#create'
  delete 'sign_out',                to: 'session#delete'
end
