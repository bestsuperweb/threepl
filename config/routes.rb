Rails.application.routes.draw do
  devise_for :users
  resources :partners
  mount ShopifyApp::Engine, at: '/'
  get 	'admin', 			to: 'partners#dashboard',		as: 'admin'
  post 	'send/emails', 		to: 'admin#send_eamils',		as: 'send_eamils'
  post 	'save/template', 	to: 'partners#save_template', 	as: 'save_template'
  
  root :to => 'admin#index'
end
