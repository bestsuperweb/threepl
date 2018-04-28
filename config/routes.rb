Rails.application.routes.draw do
  resources :partners
  mount ShopifyApp::Engine, at: '/'
  root :to => 'admin#index'
  get 'admin', to: 'partners#dashboard',  as: 'admin'
  
end
