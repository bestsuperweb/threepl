class AdminController < ShopifyApp::AuthenticatedController
  include SendGrid
  skip_before_filter :verify_authenticity_token

  def index
    @products = ShopifyAPI::Product.all
  end

  def send_eamils
  	shop     = Shop.where( shopify_domain: ShopifyAPI::Shop.current.domain ).first
    products = params[:products]
    begin
      Partner.all.each do |partner|
        options = {
          :partner  => partner,
          :shop     => shop.shopify_domain,
          :products => products
        }
        send_email(options)
      end
      
      # partners = Partner.all.collect{|partner| partner.email }
      # shop.emails.create!({products: products.collect{|p| p[1][:title]}.to_s, partners: "#{email.message_id} - #{partners.to_s}" })

      render json: { status: 'success', message: 'success to send emails' }
    rescue Exception => e
      render json: { status: 'error', message: e.to_s }
    end
  end

  private

  def send_email(options={})
    partner        = options[:partner]
    shop           = options[:shop]
    products       = options[:products]

    data = JSON.parse("{
      'personalizations': [
        {
          'to': [
            {
              'email': '#{partner.email}'
            }
          ],
          'dynamic_template_data': {
            'shop': '#{shop}'
            'products': [
                          { 
                            'img': 'https://cdn.shopify.com/s/files/1/2193/6543/products/product-image-375612158_42e298e9-fa63-4c06-83f2-ae062f8340de.jpg',
                            'title': 'Sample Product', 
                            'weight': '2.0kg',
                            'whl': '123 x 132 x 123',
                            'battery': 'Yes',
                            'notes': 'Special notes'
                          },
                          { 
                            'img': 'https://cdn.shopify.com/s/files/1/2193/6543/products/product-image-375612158_42e298e9-fa63-4c06-83f2-ae062f8340de.jpg',
                            'title': 'Sample Product', 
                            'weight': '2.0kg',
                            'whl': '123 x 132 x 123',
                            'battery': 'Yes',
                            'notes': 'Special notes'
                          }
                        ]
          },
          'subject': 'subject'
        }
      ],
      'from': {
        'email': '#{ENV['FROM_EMAIL']}'
      },
      'categories': 'category1',
      'reply_to': {
        'email': '#{ENV['FROM_EMAIL']}'
      },
      'subject': 'Products from #{shop}',
      'headers': {},
      'content': [
        {
          'type': 'text/html',
          'value': 'body'
        }
      ],
      'template_id': '#{User.all.first.template}'
    }")
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

end