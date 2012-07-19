# require 'active_support/concern'

module Qe::Concerns::Controllers::ApplicationController
	extend ActiveSupport::Concern

	def check_valid_user
		true
	end
end
