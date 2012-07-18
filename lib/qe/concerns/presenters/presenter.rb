# based on http://blog.caboo.se/articles/2007/8/23/simple-presenters
require 'active_support/concerns'

module Qe::Conerns::Presenters::class Presenter
  included do
    unloadable
    attr_accessor :controller # so we can be lazy
  end

  include ActionView::Helpers::TagHelper # link_to
  # include ActionView::Helpers::UrlHelper # url_for
  include ActionController::UrlFor # named routes
  include ActionController::RecordIdentifier # dom_id
  include Rails.application.routes.url_helpers
  
  

  def initialize(controller)
    @controller = controller
  end
  
  def request
    @controller.request
  end

end