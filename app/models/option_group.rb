class OptionGroup
  attr_reader :label
  attr_reader :group
  def initialize(label, group)
    @label = label
    @group = group
  end
end

class Option
  attr_reader :key
  attr_reader :value
  def initialize(key, value)
    @key = key
    @value = value
  end
end