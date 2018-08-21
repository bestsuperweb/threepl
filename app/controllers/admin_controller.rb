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
    products_list  = "<table>
                          <thead>
                            <tr>
                              <th>#</th>
                              <th>Image</th>
                              <th>Title</th>
                              <th>Weight</th>
                              <th>W x H x L</th>
                              <th>Has Battery?</th>
                              <th>Special Notes</th>
                            </tr>
                          </thead>"
    products.each_with_index do |product, index|
      products_list  = products_list  + "<tr>
                                            <td>#{index + 1}</td>
                                            <td><img src=#{product[1][:image]} width=\"50\" ></td>
                                            <td>#{product[1][:title]}</td>
                                            <td>#{product[1][:weight].html_safe}</td>
                                            <td>#{product[1][:whl]}</td>
                                            <td>#{product[1][:battery]}</td>
                                            <td>#{product[1][:notes]}</td>
                                          </tr>"
    end
    products_list  = products_list  + "</table>"
    mail = Mail.new
    mail.from = Email.new(email: "bestsuperweb@gmail.com")
    mail.subject = "Products from #{shop}"
    personalization = Personalization.new
    personalization.add_to(Email.new(email: partner.email))
    personalization.add_substitution(Substitution.new(key: '-shop-', value: shop.to_s))
    personalization.add_substitution(Substitution.new(key: '-products-', value: products_list.to_s))
    mail.add_personalization(personalization)
    mail.add_content(Content.new(type: 'text/html', value: "Products from #{shop}" ))
    mail.template_id = 'd-8f6b10d7d3944edd86592ff3beebf0fb'

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
        response = sg.client.mail._("send").post(request_body: mail.to_json)
    rescue Exception => e
        puts e.message
    end
    puts response.status_code
    puts response.body
    puts response.parsed_body
    puts response.headers
  end

end