# State Dropdown
# - drop down of states

module Qe::Concerns::Models::StateChooser
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::Question
  
  def choices(country = 'US')
    @states = Carmen::states(country)
  end
end
