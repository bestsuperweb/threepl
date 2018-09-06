Rails.application.routes.draw do
  resources :etemplates
  devise_for :users
  resources :partners
  mount ShopifyApp::Engine, at: '/'
  get 	'admin', 			to: 'partners#dashboard',		as: 'admin'
  post 	'send/emails', 		to: 'admin#send_eamils',		as: 'send_eamils'
  post 	'save/template', 	to: 'partners#save_template', 	as: 'save_template'
  get 	'recurring/charge', to: 'admin#create_recurring_application_charge', as: 'create_recurring_charge'
  get 	'activatecharge', 	to: 'admin#activatecharge', 	as: 'activate_charge'
  
  root :to => 'admin#index'
end
