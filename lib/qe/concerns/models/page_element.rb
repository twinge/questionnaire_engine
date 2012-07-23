module Qe::Concerns::Models::PageElement
	extend ActiveSupport::Concern

	included do
	  # self.table_name = "#{self.table_name}"
	  # acts_as_list :scope => :page
	  belongs_to :page
	  belongs_to :element

	  # TODO mass-assignment engineer the app
	  attr_accessible :page, :element, :position
	end
end