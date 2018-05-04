class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
    products = params[:products]
    respond_to do |format|
      if JSON.parse(products).first.nil?
        format.json { render json: {  status: 'success', message: JSON.parse(products).first } }
      else
        format.json { render json: {  status: 'error', message: products.to_s } }
      end
    end
  end

end