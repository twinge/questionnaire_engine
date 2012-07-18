# based on http://blog.caboo.se/articles/2007/8/23/simple-presenters

module Qe::Concerns::Presenters
  module Presenter
    extend ActiveSupport::Concern
    
    include ActionView::Helpers::TagHelper # link_to
    # include ActionView::Helpers::UrlHelper # url_for
    include ActionController::UrlFor # named routes
    include ActionController::RecordIdentifier # dom_id
    # include Rails.application.routes.url_helpers
    
    included do
      unloadable
      attr_accessor :controller # so we can be lazy
    end

    def initialize(controller)
      @controller = controller
    end
    
    def request
      @controller.request
    end

  end
end