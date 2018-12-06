Rails.application.routes.draw do
  get 'cluster/index'
  root 'cluster#index'
end
