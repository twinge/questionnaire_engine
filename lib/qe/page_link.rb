module Qe
  class PageLink 

    module M
      extend ActiveSupport::Concern
      
      included do
        include Qe::Engine.routes.url_helpers
        
        attr_accessor :dom_id, :label, :load_path, :page, :save_path
      
        def initialize(label, load_path, dom_id, page)
          @label = label
          @load_path = load_path
          @dom_id = dom_id
          @page = page
        end
      end
    end

    include M
  end
end
