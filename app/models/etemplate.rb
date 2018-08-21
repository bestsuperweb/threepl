class Etemplate < ActiveRecord::Base
	validates :template_name, presence: true
end
