class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  #   begin
  #   	template = SES.get_template({
		#   template_name: "3pl_quote_request", # required
		# })
		# if template.template
		# 	SES.update_template({
		# 	  template: { # required
		# 	    template_name: "3pl_quote_request", # required
		# 	    subject_part: "Products",
		# 	    text_part: 'Here are products: /n {{#each products}} {{id}} - {{title}}, {{weight}}, {{whl}}, {{battery}}, {{notes}} /n {{/each}}',
		# 	    html_part: 'Here are products: /n <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
	 #                			{{#each products}}
	 #                            <tr >
	 #                                <td valign=\"top\" >
	 #                                <img src={{image}} width=\"50\"  alt={{title}}>
	 #                                </td>
	 #                                <td valign=\"top\"> {{id}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{title}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{weight}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{whl}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{battery}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{notes}}
	 #                                </td>
	 #                            </tr>
	 #                            {{/each}}
	 #                            </table>',
		# 	  },
		# 	})
		# else
		# 	SES.create_template({
		# 	  template: { # required
		# 	    template_name: "3pl_quote_request", # required
		# 	    subject_part: "Products",
		# 	    text_part: 'Here are products: /n {{#each products}} {{id}} - {{title}}, {{weight}}, {{whl}}, {{battery}}, {{notes}} /n {{/each}}',
		# 	    html_part: 'Here are products: /n <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
	 #                			{{#each products}}
	 #                            <tr >
	 #                                <td valign=\"top\" >
	 #                                <img src={{image}} width=\"50\"  alt={{title}}>
	 #                                </td>
	 #                                <td valign=\"top\"> {{id}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{title}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{weight}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{whl}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{battery}}
	 #                                </td>
	 #                                <td valign=\"top\" >
	 #                                {{notes}}
	 #                                </td>
	 #                            </tr>
	 #                            {{/each}}
	 #                            </table>',
		# 	  },
		# 	})
		# end

  #   	template_data = { products: [{ id: '123123', image: 'https://cdn.shopify.com/s/files/1/2193/6543/products/product-image-375612158_42e298e9-fa63-4c06-83f2-ae062f8340de.jpg?v=1504059907', title: 'Blackbody', weight: '45lb', whl: '123 x 123 x 23', battery: 'No', notes: 'Special notes'}]}.to_json
  #   	resp = SES.test_render_template({
  #   		template_name: "3pl_quote_request", # required
  #   		template_data: template_data.to_s # required
  #   		})
  #   	@response = resp.rendered_template
  #   rescue Exception => e
  #   	@response = e
  #   end
  # @response = SES.get_send_statistics({})

  end

  def send_eamils
  	shop = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    respond_to do |format|
    	begin
    		template_data = { products: products.collect{|p| p[1].to_json } }.to_json    	
		    email = SES.send_templated_email({
			  source: ENV['FROM_EMAIL'], # required
			  destination: { # required
			    to_addresses: Partner.all.collect{|partner| partner.email },
			    cc_addresses: ['stevejeandev@gmail.com']
			  },
			  tags: [
			    {
			      name: "Shop", # required
			      value: shop.shopify_domain.gsub(/./, '_'), # required
			    },
			  ],
			  template: "3pl_quote_request", # required
			  template_data: template_data.to_s # required
			})

	    	partners = Partner.all.collect{|partner| partner.email }
	    	shop.emails.create!({products: products.collect{|p| p[1][:title]}.to_s, partners: "#{email.message_id} - #{partners.to_s}" })
    		format.json { render json: {  status: 'success' } }
    	rescue Exception => e
    		format.json { render json: {  status: "Error, #{e.to_s}" } }
    	end
    end
  end

end