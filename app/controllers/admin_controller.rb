class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
  	shop = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    respond_to do |format|
    	begin    	
		    Partner.all.each do |partner|
	    		AdminMailer.send_email(partner: partner, shop: shop.shopify_domain, products: products ).deliver_now
	    	end
	    	partners = Partner.all.collect{|partner| partner.email }
	    	shop.emails.create!({products: products.collect{|p| p[1][:title]}.to_s, partners: partners.to_s })
    		format.json { render json: {  status: 'success' } }
    	rescue Exception => e
    		format.json { render json: {  status: "Error, #{e.to_s}" } }
    	end
    end
  end

end