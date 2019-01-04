Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster/index'
    get 'users/index', to: 'users#index'
    post 'users/index', to: 'users#create'
    get 'users/modify', to: 'users#modify'
    get 'users/remove', to: 'users#remove'

    delete  '/logout',  to: 'sessions#destroy'

    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    root 'sessions#new'
  end
end
