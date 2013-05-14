module Qe
	class Paragraph < Element
    
    module M
      extend ActiveSupport::Concern

      included do
        validates_presence_of :content, :on => :update 
      end
    end

    include M
  end
end
