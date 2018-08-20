class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
  	shop = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    Partner.all.each do |partner|
      options = {
        :partner  => partner,
        :shop     => shop.domain,
        :products => products
      }
      Adminmailer.send_email(options).deliver_now
    end    
  end

end