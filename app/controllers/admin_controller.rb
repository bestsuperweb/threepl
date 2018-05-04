class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
    products = params[:products]
    respond_to do |format|
    	begin
    		Partner.all.each do |partner|

    		end
    		format.json { render json: {  status: 'success' } }
    	rescue Exception => e
    		format.json { render json: {  status: 'error' } }
    	end
    end
  end

end