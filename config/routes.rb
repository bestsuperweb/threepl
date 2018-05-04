Rails.application.routes.draw do
  resources :partners
  mount ShopifyApp::Engine, at: '/'
  get 	'admin', 		to: 'partners#dashboard',	as: 'admin'
  post 	'send/emails', 	to: 'admin#send_eamils',	as: 'send_eamils'
  
  root :to => 'admin#index'
end
