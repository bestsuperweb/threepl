class Email < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user
  has_many :products
  has_one :quote
end
