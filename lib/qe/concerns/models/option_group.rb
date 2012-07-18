require 'active_support/concerns'

module Qe::Conerns::Models::OptionGroup
	extend ActiveSupport::Concerns

	included do
	  attr_reader :label
	  attr_reader :group
	end

  def initialize(label, group)
    @label = label
    @group = group
  end
end
