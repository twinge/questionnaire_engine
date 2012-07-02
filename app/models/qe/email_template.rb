module Qe
	class EmailTemplate < ActiveRecord::Base
	  # self.table_name = "#{self.table_name}"
	  
	  validates_presence_of :name
	end
end