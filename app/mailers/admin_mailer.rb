class AdminMailer < ApplicationMailer
  default :from => 'stevejeandev@gmail.com'
  def notify_quote(quote)
  	@quote = quote
  	mail( :to => @quote.shop.owner_email,	:subject => "You have a quote from '#{@quote.user.name}'" )
  end
end