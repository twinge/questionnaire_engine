require 'active_support/concern'

module Qe::Concerns::Models::OptionGroup
	extend ActiveSupport::Concern

	included do
	  attr_reader :label
	  attr_reader :group
	end

  def initialize(label, group)
    @label = label
    @group = group
  end
end
