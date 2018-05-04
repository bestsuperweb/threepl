class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
  	shop = ShopifyAPI::Shop.current
    products = params[:products]
    respond_to do |format|
    	begin
    		merge_vars = {
		      "products" => products.to_json,
		      "shop"	 => shop.domain
		    }
    		SendMailer.send_products(merge_vars, shop.email)
    		format.json { render json: {  status: 'success' } }
    	rescue Exception => e
    		format.json { render json: {  status: "Error, #{e.to_s}" } }
    	end
    end
  end

end