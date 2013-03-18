module Qe
  module Admin
   
    module BaseControllerConfigs
      extend ActiveSupport::Concern

      included do 
        unloadable
        layout 'qe/qe.admin'
        # before_filter :check_valid_user
  	  end
  	end

  end
end