class Email < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :products, :partners
end
