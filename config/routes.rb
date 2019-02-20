Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster', to: 'cluster#index'

    get 'users', to: 'users#index'
    post 'users', to: 'users#create'
    post 'users/modify', to: 'users#modify'
    post 'users/delete', to: 'users#remove'

    get 'ssh', to: 'keys#index'
    post 'ssh', to: 'keys#create'
    post 'ssh/delete', to: 'keys#delete'

    get 'network', to: 'network#index'
    post 'network/edit', to: 'network#edit'

    post 'vpn/start', to: 'vpn#start'
    post 'vpn/stop', to: 'vpn#stop'
    post 'vpn/restart', to: 'vpn#restart'

    delete  '/logout',  to: 'sessions#destroy'

    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    root 'sessions#new'
  end
end
