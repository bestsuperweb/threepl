class ShippingOption < ActiveRecord::Base
  belongs_to :quote
  belongs_to :product
end
