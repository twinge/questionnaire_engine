module Qe::Concerns::Presenters
  module Presenter
    extend ActiveSupport::Concern
    
    include ActionView::Helpers::TagHelper      # link_to
    include ActionView::Helpers::UrlHelper      # url_for
    include ActionController::UrlFor            # named routes
    include ActionController::RecordIdentifier  # dom_id
    
    
    included do
      include Qe::Engine.routes.url_helpers

      unloadable
      attr_accessor :controller # so we can be lazy
    
      def initialize(controller)
        @controller = controller
      end
      
      def request
        @controller.request
      end
    end
  end
end
