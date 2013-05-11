module Qe
	class EmailTemplate < ActiveRecord::Base
    
    module M
      extend ActiveSupport::Concern

      included do
        validates_presence_of :name
        attr_accessible :name
      end
    end
    
    include M
  end
end  
