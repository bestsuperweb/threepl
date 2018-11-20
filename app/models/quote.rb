class Quote < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop
  belongs_to :email
  has_many	 :shipping_options
end
