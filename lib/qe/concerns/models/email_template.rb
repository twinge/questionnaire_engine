module Qe::Concerns::Models::EmailTemplate
	extend ActiveSupport::Concern	  

	included do
	  validates_presence_of :name

	  attr_accessible :name
	end
end