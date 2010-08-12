# based on http://blog.caboo.se/articles/2007/8/23/simple-presenters
class Presenter
  unloadable
  include ActionView::Helpers::TagHelper # link_to
  # include ActionView::Helpers::UrlHelper # url_for
  include ActionController::UrlFor # named routes
  include ActionController::RecordIdentifier # dom_id
  include Rails.application.routes.url_helpers
  attr_accessor :controller # so we can be lazy

  def initialize(controller)
    @controller = controller
  end
  
  def request
    @controller.request
  end

end