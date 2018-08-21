class AdminMailer < ApplicationMailer
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
    headers "X-SMTPAPI" => {
      sub:  {
        "-shop-"      => [@shop],
        "-products-"  => [@products_list]
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: User.all.first.template
          }
        }
      }
    }.to_json
    mail(:to=>@partner.email, :subject=>"Products from #{@shop}")
  end
end