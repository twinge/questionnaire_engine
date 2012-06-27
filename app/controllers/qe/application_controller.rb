module Qe
  class ApplicationController < ActionController::Base

  	# TODO allow this to be easily configured with the main app's auth procedure
  	def check_valid_user
  		true
  	end
  end
end
