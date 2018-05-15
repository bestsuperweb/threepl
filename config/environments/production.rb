Rails.application.configure do

  config.app_path = "#{ENV.fetch("HOST_URL")}/"
  config.assets.cdn_path = "#{ENV.fetch("HOST_URL")}/"
  config.assets.api_prefix = '/api/'
  config.action_controller.asset_host = ENV.fetch("HOST_URL")


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

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS"),
    authentication: :plain,
    domain: ENV.fetch("SMTP_DOMAIN"),
    enable_starttls_auto: true,
    password: ENV.fetch("SMTP_PASSWORD"),
    port: "587",
    user_name: ENV.fetch("SMTP_USERNAME")
  }
  config.action_mailer.default_url_options = { host: ENV["SMTP_DOMAIN"] }
end
