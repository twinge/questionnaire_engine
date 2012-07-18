# State Dropdown
# - drop down of states

require 'active_support/concerns'

module Qe::Conerns::Models::StateChooser < Question
	extend ActiveSupport::Concerns

  def choices(country = 'US')
    @states = Carmen::states(country)
  end
end
