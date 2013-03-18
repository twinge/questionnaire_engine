module Qe
  
  module BaseControllerConfigs
    extend ActiveSupport::Concern

    included do 
      unloadable
      layout 'qe/application'
      helper 'qe/answer_pages'
    end
  end
  
end

