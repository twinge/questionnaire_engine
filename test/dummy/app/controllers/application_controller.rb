class ApplicationController < ActionController::Base
  protect_from_forgery
 	include Qe::Concerns::Controllers::ApplicationController

 	def check_valid_user
 		true
 	end
end
