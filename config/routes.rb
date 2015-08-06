Rails.application.routes.draw do


  # Root
  # ----------------------------------------------------------------
  root                        'static_pages#home'


  # Static Pages
  # ----------------------------------------------------------------
  get     'help'          =>  'static_pages#help'
  get     'about'         =>  'static_pages#about'
  get     'contact'       =>  'static_pages#contact'


  # Users
  # ----------------------------------------------------------------
  get     'users/new'
  get     'signup'        =>  'users#new'

  resources :users


  # Sessions
  # ----------------------------------------------------------------
  get     'sessions/new'
  get     'login'         =>  'sessions#new'
  post    'login'         =>  'sessions#create'
  delete  'logout'        =>  'sessions#destroy'


  # Account Activations
  # ----------------------------------------------------------------
  get 'account_activations/edit'

  resources :account_activations, only: [:edit]


  # Password Resets
  # ----------------------------------------------------------------
  get 'password_resets/new'
  get 'password_resets/edit'

  resources :password_resets, only: [:new, :create, :edit, :update]


end
