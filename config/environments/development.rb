Rails.application.configure do

  config.app_path = 'http://localhost:3000'
  config.assets.cdn_path = 'http://localhost:3000'
  config.assets.api_prefix = '/api/'

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

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true  
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :enable_starttls_auto => true
  }  
  
end
