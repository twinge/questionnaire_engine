# State Dropdown
# - drop down of states

module Qe
	class StateChooser < Question
    
    module M
      extend ActiveSupport::Concern
    
      def choices(country = 'US')
        @states = Carmen::states(country)
      end
    end

    include M
  end
end
