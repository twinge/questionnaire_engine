# represents a link to a page for the page_list sidebar or next page links
module Qe
	class PageLink

	  attr_accessor :dom_id, :label, :load_path, :page
	  attr_accessor :save_path  # to save current page
	  
	  def initialize(label, load_path, dom_id, page)
	    @label = label
	    @load_path = load_path
	    @dom_id = dom_id
	    @page = page
	  end
	  	    
	end
end
