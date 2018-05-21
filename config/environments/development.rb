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

  config.action_mailer.smtp_settings = {
    :address => ENV["SMTP_ADDRESS"],
    :port => 587,
    :user_name => ENV["SMTP_USERNAME"], 
    :password => ENV["SMTP_PASSWORD"], 
    :authentication => :login,
    :enable_starttls_auto => true    
  }
  
  
end
