class AdminController < ShopifyApp::AuthenticatedController
  include SendGrid
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
    @application_charges = ShopifyAPI::ApplicationCharge.all || []
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
      shop.emails.create!({products: products.collect{|p| p[1][:title]}.to_s, partners: "To: #{partners.to_s}" })

      send_email(options)

      charge_request

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

  def charge_request
  	application_charge = ShopifyAPI::ApplicationCharge.new({
	  		name: 'Charge for request to send email to 3PL partners',
	  		price: 30
  		})
    application_charge.test = true
    application_charge.save
    application_charge.activate
  end

end