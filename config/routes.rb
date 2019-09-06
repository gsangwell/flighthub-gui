Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster', to: 'cluster#index'
    post 'cluster/enable_engineering_mode', to: 'cluster#enable_eng_mode'
    post 'cluster/restart', to: 'cluster#restart'
    post 'cluster/stop', to: 'cluster#stop'

    get 'users', to: 'users#index'
    post 'users', to: 'users#create'
    post 'users/modify', to: 'users#modify'
    post 'users/delete', to: 'users#remove'

    get 'console', to: 'console#index'

    delete  '/logout',  to: 'sessions#destroy'

    match '/login' => redirect('/'), via: :get

    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    match '*path', to: 'sessions#new', via: :get

    root 'sessions#new'
  end
end
