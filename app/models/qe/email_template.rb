module Qe
	class EmailTemplate < ActiveRecord::Base
	  set_table_name "#{self.table_name}"
	  
	  validates_presence_of :name
	end
end