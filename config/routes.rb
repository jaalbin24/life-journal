Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  concern :searchable do
    collection do
      get "search"
      get "search/page/:page",    action: :search
    end
  end
  resources :entries, shallow: true, concerns: [:paginatable, :searchable] do
    collection do
      get ':tab',              action: :index, constraints: { tab: /(all|published|drafts|trash)/ }, as: :tab
      get ':tab/page/:page',   action: :index, constraints: { tab: /(all|published|drafts|trash)/ }
    end
    resources :mentions, only: [:create, :new]
  end
  resource :email, only: [:edit, :update]
  resource :password, only: [:edit, :update], controller: 'passwords'
  resources :users, except: [:index, :new] do
    member do
      get ':tab',               action: :show, constraints: { tab: /(account)/ }, as: :tab
      get ':tab/page/:page',    action: :show, constraints: { tab: /(account)/ }
    end
  end
  resources :people, shallow: true, concerns: [:paginatable, :searchable] do
    collection do
      get ':tab',               action: :index, constraints: { tab: /(all|trash)/ }, as: :tab
      get ':tab/page/:page',    action: :index, constraints: { tab: /(all|trash)/ }
    end
    resources :notes, only: [:create, :index]
    member do
      get ':tab',               action: :show, constraints: { tab: /(biography|notes|mentions|info)/ }, as: :tab
      get ':tab/page/:page',    action: :show, constraints: { tab: /(biography|notes|mentions|info)/ }
    end
  end
  resources :mentions
  resources :notes, only: [:destroy]
  get 'day/:month-:day-:year', to: 'days#show', as: "day"

  root to: 'pages#home'

  get 'sign-up',                    to: 'users#new', as: :new_user
  get 'sign-in',                    to: 'session#new'
  post 'sign-in',                   to: 'session#create'
  delete 'sign-out',                to: 'session#delete'
end
