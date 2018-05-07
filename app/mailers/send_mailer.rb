class SendMailer < BaseMandrillMailer
  def send_products(vars, email)
    subject = "Products"
    body = mandrill_template("products", vars)
    send_mail(email, subject, body)
  end
end