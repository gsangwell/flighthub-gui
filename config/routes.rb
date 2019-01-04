Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster/index'

    get 'users', to: 'users#index'
    post 'users', to: 'users#create'

    delete  '/logout',  to: 'sessions#destroy'

    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    root 'sessions#new'
  end
end
