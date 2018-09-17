class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable, :lockable

  has_many :emails
  has_many :quotes
  
  def send_devise_notification(notification, *args)
	 devise_mailer.send(notification, self, *args).deliver_later
  end

  def admin?
  	self.admin
  end

end
