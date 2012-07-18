require 'active_support/concern'

module Qe::Concerns::Models::EmailTemplate
	extend ActiveSupport::Concern	  

	included do  
		# self.table_name = "#{self.table_name}"
	  validates_presence_of :name
	end
end