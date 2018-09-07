class AdminController < ShopifyApp::AuthenticatedController
  include SendGrid
  skip_before_filter :verify_authenticity_token

  def index
    @products 				= ShopifyAPI::Product.all
    @recurring_charge 		= ShopifyAPI::RecurringApplicationCharge.current
    @usage_charges 			= ShopifyAPI::UsageCharge.where({recurring_application_charge_id: @recurring_charge.id}) || []
    emails  				= Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first.emails
    @emails 				= {}
    emails.each{ |email| @emails["#{email.charge_id}"] = email }
  end

  def create_recurring_application_charge
	  unless ShopifyAPI::RecurringApplicationCharge.current
	    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
	            name: "Sourcify 3PL Bidding System Plan",
	            price: 0.00,
	            return_url: "#{root_url}/activatecharge",
	            test: true,
	            trial_days: 7,
	            capped_amount: 100,
	            terms: "$30 for every request to send emails to 3PL partners")

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


  def send_eamils
  	shop     = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    begin
      options = {
          :shop     => shop.shopify_domain,
          :products => products
        }     
      
      partners = Partner.all.collect{|partner| partner.email }

      charge_id = create_usage_charge

      shop.emails.create!({ 
      	products: products.collect{|p| p[1][:title]}.to_s, 
      	partners: partners.to_s, 
      	charge_id: charge_id })          

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
      "template_id": "' + User.all.first.template + '"
    }')

    data['personalizations'].first['to'] = Partner.all.collect{|p| { 'email': p.email, 'name': p.name } }
    data['personalizations'].first['dynamic_template_data']['products'] = products_list

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
        response = sg.client.mail._("send").post(request_body: data)
    rescue Exception => e
        puts e.message
    end
    puts response.status_code
    puts response.body
    puts response.parsed_body
    puts response.headers

  end

  def create_usage_charge
	  usage_charge = ShopifyAPI::UsageCharge.new(description: "$30 for every request to send emails to 3PL partners", price: 30)
	  recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
	  usage_charge.prefix_options = {recurring_application_charge_id: recurring_application_charge.id}
	  usage_charge.save
	  usage_charge.id
  end

end