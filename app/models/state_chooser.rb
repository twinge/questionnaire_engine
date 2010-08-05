# State Dropdown
# - drop down of states

class StateChooser < Question
  def choices
    @states = State::NAMES
  end
end