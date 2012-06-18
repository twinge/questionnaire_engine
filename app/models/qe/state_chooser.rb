# State Dropdown
# - drop down of states

module Qe
	class StateChooser < Question
	  def choices(country = 'US')
	    @states = Carmen::states(country)
	  end
	end
end
