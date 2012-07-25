# Section
# - Represents a subheading

# :kind         - 'Section' for single table inheritance (STI)
# :label        - title for this section such as "Contact information"
# :style        - ?
# :content      - ? instructions, agreements, etc. to display

module Qe
	class Section < Element  
    include Qe::Concerns::Models::Section
  end
end
