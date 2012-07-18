# Section
# - Represents a subheading

# :kind         - 'Section' for single table inheritance (STI)
# :label        - title for this section such as "Contact information"
# :style        - ?
# :content      - ? instructions, agreements, etc. to display

require 'active_support/concern'

module Qe::Concerns::Models::Section
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::Element
end