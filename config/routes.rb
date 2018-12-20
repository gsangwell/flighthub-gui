Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster/index'

    delete  '/logout',  to: 'sessions#destroy'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    root 'sessions#new'
  end
end
