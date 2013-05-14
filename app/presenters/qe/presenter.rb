module Qe
  class Presenter
    
    module M
      extend ActiveSupport::Concern
      
      included do 
        unloadable
        include ActionView::Helpers::TagHelper      # link_to
        include ActionView::Helpers::UrlHelper      # url_for
        include ActionController::UrlFor            # named routes
        include ActionController::RecordIdentifier  # dom_id
        include Qe::Engine.routes.url_helpers
      end

      attr_accessor :controller
    
      def initialize(controller)
        @controller = controller
      end
      
      def request
        @controller.request
      end

    end

    include M
  end
end  
