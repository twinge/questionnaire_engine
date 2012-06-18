module Qe
	class PageElement < ActiveRecord::Base
	  set_table_name "#{self.table_name}"
	  # set_table_name "qe_page_element"
	  # acts_as_list :scope => :qe_page
	  belongs_to :page
	  belongs_to :element
	end
end