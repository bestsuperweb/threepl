class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
    begin
    	template_data = { products: [{ image: 'https://cdn.shopify.com/s/files/1/2193/6543/products/product-image-375612158_42e298e9-fa63-4c06-83f2-ae062f8340de.jpg?v=1504059907', title: 'Blackbody', weight: '45lb', whl: '123 x 123 x 23', battery: 'No', notes: 'Special notes'}]}
    	resp = client.test_render_template({
    		template_name: "3pl_quote_request", # required
    		template_data: template_data, # required
    		})
    	@response = resp.rendered_template
    rescue Exception => e
    	@response = e
    end
  end

  def send_eamils
  	shop = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    respond_to do |format|
    	begin
    		template_data = { products: products.collect{|p| p[1].to_json } }    	
		    SES.send_templated_email({
			  source: ENV['FROM_EMAIL'], # required
			  destination: { # required
			    to_addresses: Partner.all.collect{|partner| partner.email },
			    cc_addresses: 'stevejeandev@gmail.com'
			  },
			  tags: [
			    {
			      name: "Shop", # required
			      value: shop.shopify_domain, # required
			    },
			  ],
			  template: "3pl_quote_request", # required
			  template_data: template_data, # required
			})

	    	partners = Partner.all.collect{|partner| partner.email }
	    	shop.emails.create!({products: products.collect{|p| p[1][:title]}.to_s, partners: partners.to_s })
    		format.json { render json: {  status: 'success' } }
    	rescue Exception => e
    		format.json { render json: {  status: "Error, #{e.to_s}" } }
    	end
    end
  end

end