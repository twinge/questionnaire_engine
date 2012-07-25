# AttachmentField
# - a file upload question

require 'qe/concerns/models/question'

module Qe::Concerns::Models::AttachmentField
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::Question
end
