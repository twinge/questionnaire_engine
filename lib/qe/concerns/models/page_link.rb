require 'active_support/concerns'

# represents a link to a page for the page_list sidebar or next page links
module Qe::Conerns::Models::PageLink
	extend ActiveSupport::Concerns
	
	included do
	  attr_accessor :dom_id, :label, :load_path, :page
	  attr_accessor :save_path  # to save current page
	end

  def initialize(label, load_path, dom_id, page)
    @label = label
    @load_path = load_path
    @dom_id = dom_id
    @page = page
  end
  	    
end
