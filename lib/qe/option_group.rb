module Qe
  class OptionGroup 
    attr_reader :label
    attr_reader :group
  
    def initialize(label, group)
      @label = label
      @group = group
    end
  end
end
