Rails.application.routes.draw do

	# partner routes
  get 	'home', 			to: 'static#home', 			as: 'home'
  get 	'dashboard', 		to: 'static#dashboard', 	as: 'dashboard'
  get 	'emails',	 		to: 'static#emails', 		as: 'emails'
  get 	'quote/:id/new',	to: 'static#new_quote', 	as: 'new_quote'
  post 	'quote', 			to: 'static#create_quote', 	as: 'create_quote'
  get 	'quote', 			to: 'static#show_quote', 	as: 'show_quote'
  get 	'email/:id',		to: 'static#show_email',	as: 'show_email'
  get 	'setting', 			to: 'static#setting', 		as: 'setting'
  post  'save/template', 	to: 'static#save_template', as: 'save_template'

  resources :etemplates
  devise_for :users
  mount ShopifyApp::Engine, at: '/'
  post 	'send/emails', 		to: 'admin#send_emails',		as: 'send_emails'
  get 	'recurring/charge', to: 'admin#create_recurring_application_charge', as: 'create_recurring_charge'
  get 	'activatecharge', 	to: 'admin#activatecharge', 	as: 'activate_charge'
  
  root :to => 'admin#index'
end
