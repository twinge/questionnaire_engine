class ApplicationController < ActionController::Base
  protect_from_forgery

 	def check_valid_user
 		true
 	end
end
