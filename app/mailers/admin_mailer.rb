class AdminMailer < ApplicationMailer
  include SendGrid
  def send_email(options={})
    @partner 	      = options[:partner]
    @shop 		      = options[:shop]
    @products 	    = options[:products]
    @products_list  = "<table>
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
    @products.each_with_index do |product, index|
      @products_list  = @products_list  + "<tr>
                                            <td>#{index + 1}</td>
                                            <td><img src=#{product[1][:image]} width=\"50\" ></td>
                                            <td>#{product[1][:title]}</td>
                                            <td>#{product[1][:weight].html_safe}</td>
                                            <td>#{product[1][:whl]}</td>
                                            <td>#{product[1][:battery]}</td>
                                            <td>#{product[1][:notes]}</td>
                                          </tr>"
    end
    @products_list  = @products_list  + "</table>"
    mail = Mail.new
    mail.from = Email.new(email: @partner.email)
    mail.subject = "Products from #{@shop}"
    personalization = Personalization.new
    personalization.add_to(Email.new(email: @partner.email))
    personalization.add_substitution(Substitution.new(key: '-shop-', value: @shop))
    personalization.add_substitution(Substitution.new(key: '-products-', value: @products_list))
    mail.add_personalization(personalization)
    mail.add_content(Content.new(type: 'text/html', value: "Products from #{@shop}" ))
    mail.template_id = User.all.first.template

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