Rails.application.configure do

  config.app_path = "#{ENV.fetch("HOST_URL")}/"
  config.assets.cdn_path = "#{ENV.fetch("HOST_URL")}/"
  config.assets.api_prefix = '/api/'
  config.action_controller.asset_host = ENV.fetch("HOST_URL")
  config.assets.compile = false # Disables security vulnerability


  config.log_level = :info

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

   # remove if no need
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'threepl.herokuapp.com' }
  config.action_mailer.asset_host = 'https://threepl.herokuapp.com'

  ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => 'heroku.com',
      :enable_starttls_auto => true
  }

end
