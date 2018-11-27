class StaticController < ApplicationController
  before_action :authenticate_user!, :except => [:home]
  def home
  end

  def dashboard
  	@emails 			= current_user.emails

  	@pending_emails 	= current_user.emails.where(:status => 'pending')
  	@submitted_emails 	= current_user.emails.where(:status => 'submitted')
  	
  	@quotes 			= current_user.quotes

  	if current_user.admin?
  		@emails = Email.all
  		@shops 	= Shop.all
  	end
  end

  def emails
  	@submitted_emails 	= current_user.emails.where( :status => 'submitted' )
  	@pending_emails 	= current_user.emails.where( :status => 'pending' )
  end

  def create_quote
  	@quote = Quote.new quote_params
  	@email = Email.find quote_params[:email_id]
  	if @quote.save
  		flash[:notice] = "Successfully sent quote - ##{@quote.id}..."
  		@email.status  = 'submitted'
  		if @email.save
  			@email.products.each do |product|
  				shipping_option = @quote.shipping_options.build(
						  					shipping_option1: shipping_params["#{product.id}"][0],
						  					shipping_option2: shipping_params["#{product.id}"][1],
						  					shipping_option3: shipping_params["#{product.id}"][2],
						  					shipping_option4: shipping_params["#{product.id}"][3],
						  					shipping_option5: shipping_params["#{product.id}"][4],
						  					product_id: product.id 
					  					)
  				shipping_option.save
  			end
  		end
  		AdminMailer.notify_quote(@quote).deliver_now
  		redirect_to dashboard_path
  	else
  		flash[:notice] = "There are some error to send quote..."
  		redirect_to show_email_path
  	end
  end

  def show_email
  	@email = Email.find params[:id]
  	@quote = @email.quote
  end

  def setting
  	redirect_to dashboard_url, notice: "You can't access this page..." unless current_user.admin?
  	@users 	= User.all.where(:admin => nil)
  	@shops 	= Shop.all
  end

  def save_template
  	template = params[:template]
    current_user.template = template
    if current_user.save
      redirect_to setting_url, notice: 'Template was successfully updated.'
    else
      redirect_to setting_url, error: 'There is error to save template.'
    end
  end

  private

  	def quote_params
      params.require(:quote).permit(
      	:first_unit1,
      	:first_unit2,
      	:first_unit3,
      	:first_unit4,
      	:first_unit5,
      	:additional1,
      	:additional2,
      	:additional3,
      	:additional4,
      	:additional5,
      	:packaging_cost1,
      	:packaging_cost2,
      	:packaging_cost3,
      	:packaging_cost4,
      	:packaging_cost5,
      	:storage_cost1,
      	:storage_cost2,
      	:storage_cost3,
      	:storage_cost4,
      	:storage_cost5,
      	:international_fee1,
      	:international_fee2,
      	:international_fee3,
      	:international_fee4,
      	:international_fee5,
      	:warehousing_option1,
      	:warehousing_option2,
      	:warehousing_option3,
      	:warehousing_option4,
      	:warehousing_option5,
      	:email_id, :user_id, :shop_id
      	)
    end

    def shipping_params
    	params.require(:shipping_option)
    end

end
