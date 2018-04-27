Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  root :to => 'admin#index'
  
end
