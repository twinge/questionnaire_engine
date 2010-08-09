# State Dropdown
# - drop down of states

class StateChooser < Question
  def choices(country = 'US')
    @states = Carmen::states(country)
  end
end