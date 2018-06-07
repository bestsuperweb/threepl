class Template < ActiveRecord::Base
	validates :template_name, presence: true
end
