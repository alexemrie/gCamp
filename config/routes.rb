Rails.application.routes.draw do

  get '/signup' => 'registrations#new'
  post '/signup' => 'registrations#create'
  get '/signout' => 'authentication#destroy'
  get '/signin' => 'authentication#new'
  post '/signin' => 'authentication#create'


  root 'welcome#index'
  get '/terms' => 'terms#index'
  get '/about' => 'about#index'
  get '/faq' => 'common_questions#index'


  resources :users
  resources :projects do
    resources :tasks
    resources :memberships
  end

  resources :tasks, only: [] do
    resources :comments, only: [:create]
  end

  resources :tracker_projects, only: [:show]
end
