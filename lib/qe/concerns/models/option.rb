require 'active_support/concern'

module Qe::Concerns::Models::Option
	extend ActiveSupport::Concern

	included do
	  attr_reader :key
	  attr_reader :value
	end

	def initialize(key, value)
    @key = key
    @value = value
  end
end
