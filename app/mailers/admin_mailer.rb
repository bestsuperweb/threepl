class AdminMailer < ApplicationMailer
  def send_email(options={})
    @partner 	= options[:partner]
    @shop 		= options[:shop]
    @products 	= options[:products]
    mail(:to=>@partner.email, :subject=>"Products from #{@shop}")
  end
end