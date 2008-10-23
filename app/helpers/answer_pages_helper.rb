module AnswerPagesHelper
  
  # page sidebar navigation
  def li_page_active_if(condition, attributes = {}, &block)
    if condition
      attributes["class"] = "active"
    end
    content_tag("li", attributes, &block)
  end
  
  # prepares the javascript function call to load a page
  def load_page_js(page_link)
    return '' if page_link.nil?
    
    %{page_handler.loadPage('#{page_link.dom_id}','#{page_link.load_path}')}
  end
  
end
