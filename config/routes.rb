MyWinningTrade::Application.routes.draw do

  root to: redirect('/dashboard')

  match '/auth/:provider/callback', to: 'sessions#create'

  post 'sessions/create', to: 'sessions#create'

  get '/auth/failure', to: 'sessions#new'

  get '/dashboard', to: 'stock#dashboard'
  get '/user/trading_analysis', to: 'stock#trading_analysis'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  get '/AboutUs', to: 'sessions#aboutus'
  get '/Education', to: 'sessions#education'
  get '/Press', to: 'sessions#press'
  get '/Portal', to: 'sessions#loginportal'

  get '/terms', to: 'terms#show', as: :terms
  post '/terms/accept', to: 'terms#accept', as: :accept_terms

  get 'buys/callback_linkedin', to: 'buys#callback_linkedin'
  get 'buys/callback_facebook', to: 'buys#callback_facebook'

  get 'sells/callback_linkedin', to: 'sells#callback_linkedin'
  get 'sells/callback_facebook', to: 'sells#callback_facebook'

  get '/users/profile', to: 'users#profile', as: 'profile'
  get '/signin', to: 'users#sign_in'
  get '/signup', to: 'users#sign_up'
  get '/user/edit', to: 'users#edit'
  put '/user/update', to: 'users#update'
  post '/user/create', to: 'users#create'

  get '/trading_analysis_pdf', to: 'users#trading_analysis_pdf'

  get '/subscriptions', to: 'subscriptions#show'
  post '/subscriptions/create', to: 'subscriptions#create'
  match '/subscriptions/destroy', to: 'subscriptions#destroy'
  match '/subscriptions/update', to: 'subscriptions#update'

  resources :teacher_sessions, only: [:create]
  get 'teacher/sign_in', to: 'teacher_sessions#new'
  get 'teacher/request_upgrade', to: 'teacher_sessions#request_upgrade'
  post 'teacher/verify', to: 'teacher_sessions#verify'
  post 'teacher/remove_pending', to: 'teacher_sessions#remove_pending'
  get 'teacher/pending', to: 'teacher_sessions#pending'
  delete 'teacher/log_out', to: 'teacher_sessions#destroy'

  get "account_bonuses", to: "account_bonuses#show"
  post "account_bonuses/create"

  resources :groups
  get '/search_students', to: 'groups#search_students'

  #get 'new_group', to: 'groups#new'

  get '/joestest', to: 'users#test'

  resources :stock, only: :show, constraints: { id: /[a-zA-Z0-9\.\-]{1,20}/ } do
    member do
      get :price_history
    end

    collection do
      get :details
      get :search
      get :portfolio
    end

    resource :buy, only: :create
    resource :sell, only: :create
    resource :short_sell_borrow, only: :create
    resource :short_sell_cover, only: :create
    resource :date_time_transaction, only: [:create, :destroy]
    resource :stop_loss_transaction, only: [:create, :destroy]
  end

  resources :orders, only: [:index]

  root to: redirect('/dashboard')

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      post 'users/authenticate' => 'users#authenticate'
      post 'users/create' => 'users#create'
      delete 'users/destroy' => 'users#destroy'
      match '/auth/:provider/callback', to: 'users#authenticate'

      resources :buys, only: :create
      resources :sells, only: :create
      resources :short_sell_borrows, only: :create

      resources :stocks do
        collection do
          post 'search'
          post 'details'
        end
      end
      resources :users do
        collection do
          post 'pending_date_time_transactions'
          post 'pending_stop_loss_transactions'
          post 'portfolio'
          post 'stock_info'
          post 'stock_order_history'

        end
      end
      resource :short_sell_borrows, only: :create
      resource :short_sell_covers, only: :create
      resource :date_time_transactions, only: [:create, :destroy]
      resource :stop_loss_transactions, only: [:create, :destroy]
    end
  end

end
