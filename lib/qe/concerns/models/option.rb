require 'active_support/concerns'

module Qe::Conerns::Models::Option
	extend ActiveSupport::Concerns

	included do
	  attr_reader :key
	  attr_reader :value
	end

	def initialize(key, value)
    @key = key
    @value = value
  end
end
