# based on http://blog.caboo.se/articles/2007/8/23/simple-presenters
class Presenter
  include ActionView::Helpers::TagHelper # link_to
  include ActionView::Helpers::UrlHelper # url_for
  include ActionController::UrlWriter # named routes
  include SimplyHelpful::RecordIdentifier # dom_id
  attr_accessor :controller # so we can be lazy

  def initialize(controller)
    @controller = controller
  end

  alias :html_escape :h
  def html_escape(s) # I couldn't figure a better way to do this
    s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "\&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;") #>
  end  

end