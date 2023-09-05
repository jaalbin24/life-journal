Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  concern :recoverable do
    member do
      post 'recover'
      post 'mark_as_deleted'
    end
  end
  concern :searchable do
    collection do
      get "search"
      get "search/page/:page",    action: :search
    end
  end
  resources :entries, shallow: true, concerns: [:paginatable, :recoverable, :searchable] do
    collection do
      get ':tab',              action: :index, constraints: { tab: /(all|published|drafts|trash)/ }, as: :tab
      get ':tab/page/:page',   action: :index, constraints: { tab: /(all|published|drafts|trash)/ }
    end
    resources :mentions, only: [:create, :new]
  end
  resources :users, except: [:index, :new] do
    member do
      get ':tab',               action: :show, constraints: { tab: /(account)/ }, as: :tab
      get ':tab/page/:page',    action: :show, constraints: { tab: /(account)/ }
    end
  end
  resources :people, shallow: true, concerns: [:paginatable, :recoverable, :searchable] do
    collection do
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

  get 'sign-up',                    to: 'users#new', as: :new_user
  get 'sign-in',                    to: 'session#new'
  post 'sign-in',                   to: 'session#create'
  delete 'sign-out',                to: 'session#delete'

end
