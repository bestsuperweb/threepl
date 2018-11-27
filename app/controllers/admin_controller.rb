class AdminController < ShopifyApp::AuthenticatedController
  include SendGrid
  skip_before_filter :verify_authenticity_token

  def index

  	shop     = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
  	
  	if shop.owner_email.nil? or shop.shop_name.nil?
  		owner_email = ShopifyAPI::Shop.current.email
  		shop_name 	= ShopifyAPI::Shop.current.name
  		shop.owner_email = owner_email unless shop.owner_email == owner_email
  		shop.shop_name = shop_name unless shop.shop_name == shop_name
  		shop.save
  	end

    @products 				= ShopifyAPI::Product.all
    @recurring_charge 		= ShopifyAPI::RecurringApplicationCharge.current

    if @recurring_charge.nil?
    	@usage_charges 		= []
    else
    	@usage_charges 		= ShopifyAPI::UsageCharge.where({recurring_application_charge_id: @recurring_charge.id})
    end
    	
    @emails  				= shop.emails
    @submitted_emails 		= shop.emails.where( :status => 'submitted' )
  	@pending_emails 		= shop.emails.where( :status => 'pending' )
    @quotes 				= shop.quotes
    @users 					= User.all.where(:admin => nil)
    
  end

  def quotes
  	shop     	= Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
  	@quotes 	= shop.quotes
  end

  def email_details
  	shop     	= Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
  	@email 		= shop.emails.find params[:id]
  	@quote 		= @email.quote
  end

  def create_recurring_application_charge
	  unless ShopifyAPI::RecurringApplicationCharge.current
	    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
	            name: "Sourcify 3PL Bidding System Plan",
	            price: 30.00,
	            return_url: "#{root_url}/activatecharge",
	            test: true,
	            trial_days: 7,
	            capped_amount: 100,
	            terms: "$0.00 for every request to send emails to 3PL partners")

	    if recurring_application_charge.save
	      fullpage_redirect_to recurring_application_charge.confirmation_url
	    end
	  end
  end

  def activatecharge
  	recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(request.params['charge_id'])
  	if recurring_application_charge.status == "accepted"
  		recurring_application_charge.activate
  	end
  	redirect_to root_url
  end


  def send_emails
  	shop     		= Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products 		= params[:products]
    products_list  	= products.collect{|p| p[1] }
    begin
      options = {
          :shop     => shop.shop_name,
          :products => products
        }     
      
      partners = User.all.where(:admin => nil)

      # charge_id = create_usage_charge

      partners.each do |partner|
      	email = shop.emails.create!({ status: 'pending', user_id: partner.id })
      	products_list.each do |product|
      		# puts "product = ..."
      		email.products.create!(product.to_hash)
      	end
      end

      send_email(options)

      render json: { status: 'success', message: 'success to send emails' }
    rescue Exception => e
      render json: { status: 'Success', message: e.to_s }
    end
  end

  private

  def send_email(options={})
    shop           = options[:shop]
    products       = options[:products]
    products_list  = products.collect{|p| p[1] }

    data = JSON.parse('{
      "personalizations": [
        {          
          "dynamic_template_data": {
            "shop": "' + shop + '"
          },
          "subject": "subject"
        }
      ],
      "from": {
        "email": "' + ENV['FROM_EMAIL'] + '"
      },
      "content": [
        {
          "type": "text/html",
          "value": "body"
        }
      ],
      "template_id": "' + User.all.where(:admin => true).first.template + '"
    }')

    data['personalizations'].first['to'] = User.all.where(:admin => nil).collect{|p| { 'email': p.email, 'name': p.name } }
    data['personalizations'].first['dynamic_template_data']['products'] = products_list

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
        response = sg.client.mail._("send").post(request_body: data)
    rescue Exception => e
        puts e.message
    end

    puts "status code = #{response.status_code}"
    puts "response body = #{response.body}"
    puts "parsede body = #{response.parsed_body}"
    puts "headers = #{response.headers}"

  end

  def create_usage_charge
	  usage_charge = ShopifyAPI::UsageCharge.new(description: "$30 for every request to send emails to 3PL partners", price: 30)
	  recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
	  usage_charge.prefix_options = {recurring_application_charge_id: recurring_application_charge.id}
	  usage_charge.save
	  usage_charge.id
  end

end