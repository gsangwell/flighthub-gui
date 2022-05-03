require 'constraints/setup_wizard_constraint'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Constraints::SetupWizardConstraint.new do
    get '/setup',   to: 'setup#start'

    get '/setup/user',    to: 'setup#user'
    post '/setup/user',    to: 'setup#createUser'

    get '/setup/network',    to: 'setup#network'
    post '/setup/network',    to: 'setup#configureNetwork'

    get '/setup/finish',     to: 'setup#finish'
    post '/setup/finish',    to: 'setup#doFinish'

    match '*path', to: 'setup#start', via: :get
    root 'setup#start'
  end

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster', to: 'cluster#index'
    post 'cluster/restart', to: 'cluster#restart'
    post 'cluster/stop', to: 'cluster#stop'

    post 'cluster/support-enable', to: 'cluster#enable_remote_support'
    post 'cluster/support-disable', to: 'cluster#disable_remote_support'

    get 'users', to: 'users#index'
    post 'users', to: 'users#create'
    post 'users/modify', to: 'users#modify'
    post 'users/delete', to: 'users#remove'

    get 'console', to: 'console#index'

    delete  '/logout',  to: 'sessions#destroy'

    match '/login' => redirect('/'), via: :get

    get 'network', to: 'network#index'
    post 'network/configure', to: 'network#configure'

    get 'ssl', to: 'ssl#index'
    post 'ssl/csr', to: 'ssl#csr'
    post 'ssl/cert', to: 'ssl#cert'

    match '*path', to: 'cluster#index', via: :get
    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    match '*path', to: 'sessions#new', via: :get

    root 'sessions#new'
  end

end
