class SendMailer < BaseMandrillMailer
  def send_products(vars, shop)
    subject = "Products"
    body = mandrill_template("products", vars)

    Partner.all.each do |partner|
      send_mail(partner.email, subject, body, shop)
    end    
  end
end