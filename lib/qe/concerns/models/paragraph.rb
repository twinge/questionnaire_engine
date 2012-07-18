# Paragraph
# - Represents a block of content
#
# :kind         - 'Paragraph' for single table inheritance (STI)
# :content      - instructions, agreements, etc. to display

require 'active_support/concerns'

module Qe::Conerns::Models::Paragraph < Element
	extend ActiveSupport::Concerns

	included do
	  validates_presence_of :content, :on => :update 
	end
end
