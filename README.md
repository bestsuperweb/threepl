# routeOnShopify

This shopify application is Carbon Checkout app for shopify store.


* Ruby version 
	* ruby 2.3.4

* System dependencies
	* rails 4.2.5.1
	* postgresql (production environment)
	* sqlite3 (development environment)
	* Read Gemfile for the more...

* Configuration
	- Shopify app configuration: config/initializers/shopify_app.rb
		- `config.api_key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'` ( API key in your shopify partner dashboard )
  		- `config.secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'` ( API secret key in your shopify partner dashboard )

* Database creation & initialization
	* local: `rake db:migrate`
	* heroku: `heroku run rake db:migrate`

* How to run this app in your local
	- Install rvm on your local ( http://railsapps.github.io/installrubyonrails-mac.html )
	- Install ruby 2.3.4 and bundler using rvm if you have not ruby 2.3.4 installed on your local
		- `rvm install ruby-2.3.4`
		- `gem install bundler`
	- Install gems for this app: `bundle install`
	- Migrate db using: `rake db:migrate`
	- Run rails server using: `rails s`
	- Launch ngrok to make your local server to the public using ngrok: `ngrok http 3000`
	- Register forwarding url to `App URL` and `Whitelisted redirection URL(s)` in shopify partner app info:

		`Forwarding            http://xxxxxx.ngrok.io -> localhost:3000`      
		`Forwarding            https://xxxxxx.ngrok.io -> localhost:3000`

	- Finally type ngrok forwarding url ( `https://xxxxxx.ngrok.io` ) in your browser and hit enter.

* How to deploy app to heroku and run
	- Create heroku app
	- Deploy this app to heroku using github or heroku-cli
	- Database migrate for heroku app
	- Register heroku app url ( eg: `https://xxxxxx.herokuapp.com` ) to `App URL` and `Whitelisted redirection URL(s)` in shopify partner app info
	- At the end, type heroku app url in your browser and hit enter.
