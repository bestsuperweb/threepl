class Email < ActiveRecord::Base
  belongs_to :shop
  validates :products, presence: true
  validates :partners, presense: true
end
