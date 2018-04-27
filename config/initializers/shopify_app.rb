ShopifyApp.configure do |config|
  config.api_key = ENV['API_KEY']
  config.secret = ENV['SECRET_KEY']
  config.scope = "read_orders, write_orders, write_products, read_products, read_themes, write_themes"
  config.embedded_app = true
end
