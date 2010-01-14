# represents a link to a page for the page_list sidebar or next page links
class PageLink

  attr_accessor :dom_id, :label, :load_path
  attr_accessor :save_path  # to save current page
  
  def initialize(label, load_path, dom_id, save_path = nil)
    @label = label
    @load_path = load_path
    @dom_id = dom_id
    @save_path = save_path
  end
    
end