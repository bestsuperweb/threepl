class SendMailer < BaseMandrillMailer
  def send_products(products, shop)
    subject = "Products"
    body = mandrill_template("products", products)

    Partner.all.each do |partner|
      send_mail(partner.email, subject, body, shop)
    end    
  end
end