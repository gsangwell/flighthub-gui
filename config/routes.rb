Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  constraints Clearance::Constraints::SignedIn.new do
    get 'cluster', to: 'cluster#index'
    post 'cluster/enable_engineering_mode', to: 'cluster#enable_eng_mode'
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
    
    post 'firewall/add-ssh', to: 'network#add_ssh_service'
    post 'firewall/remove-ssh', to: 'network#remove_ssh_service'

    get 'ssh', to: 'keys#index'
    post 'ssh', to: 'keys#create'
    post 'ssh/delete', to: 'keys#delete'

    root 'cluster#index'
  end

  constraints Clearance::Constraints::SignedOut.new do
    get     '/login',   to: 'sessions#new'
    post    '/login',   to: 'sessions#create'

    match '*path', to: 'sessions#new', via: :get

    root 'sessions#new'
  end
end
