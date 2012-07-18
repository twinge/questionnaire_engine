require 'active_support/concerns'

module Qe::Conerns::Models::EmailTemplate
	extend ActiveSupport::Concerns
	  
	included do  
		# self.table_name = "#{self.table_name}"
	  validates_presence_of :name
	end
end