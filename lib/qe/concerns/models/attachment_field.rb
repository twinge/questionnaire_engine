require 'active_support/concern'
require 'qe/concerns/models/question'

# AttachmentField
# - a file upload question

module Qe::Concerns::Models::AttachmentField
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::Question
end
