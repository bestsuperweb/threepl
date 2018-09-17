class StaticController < ApplicationController
  before_action :authenticate_user!, :except => [:home]
  def home
  end

  def dashboard
  	@emails 			= current_user.emails

  	@pending_emails 	= current_user.emails.where(:status => 'pending')
  	@sent_emails	 	= current_user.emails.where(:status => 'sent')
  	
  	@quotes 			= current_user.quotes
  end

  def create_quote
  	@quote = Quote.new quote_params
  	@email = Email.find quote_params[:email_id]
  	if @quote.save
  		flash[:notice] = "Successfully sent quote - ##{@quote.id}..."
  		@email.status  = 'sent'
  		@email.save
  		redirect_to dashboard_path
  	else
  		flash[:notice] = "There are some error to send quote..."
  		redirect_to quote_path
  	end
  end

  def new_quote
  	@email = Email.find params[:id]
  end

  def show_quote
  	@quote = Quote.find params[:id]
  end

  def show_email
  	@email = Email.find params[:id]
  end

  def setting
  end

  private

  	def quote_params
      params.require(:quote).permit(:pp_fee, :storage_cost, :internation_fee, :shipping_option, :warehousing_option, :email_id, :user_id, :shop_id)
    end

end
