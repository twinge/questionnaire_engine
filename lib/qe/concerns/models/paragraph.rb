# Paragraph
# - Represents a block of content
#
# :kind         - 'Paragraph' for single table inheritance (STI)
# :content      - instructions, agreements, etc. to display

module Qe::Concerns::Models::Paragraph
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::Element

	included do
	  validates_presence_of :content, :on => :update 
	end
end
