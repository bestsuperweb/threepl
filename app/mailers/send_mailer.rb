class SendMailer < BaseMandrillMailer
	default from: ENV["FROM_EMAIL"]

	def send_products(vars, email)
		subject = "Products"
		# body = mandrill_template("products", vars)
		body 	= "Hello Message!!!"
		send_mail(email, subject, body)
	end
end