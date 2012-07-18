require 'active_support/concerns'

module Qe::Conerns::Models::PageElement
	extend ActiveSupport::Concerns

	included do
	  # self.table_name = "#{self.table_name}"
	  # set_table_name "qe_page_element"
	  # acts_as_list :scope => :page
	  belongs_to :page
	  belongs_to :element

	  # TODO mass-assignment engineer the app
	  attr_accessible :page, :element, :position
	end
end