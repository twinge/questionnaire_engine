# QuestionGrid
# - Represents a grid layout of a set of questions, with a total at the bottom
#
# :kind         - 'QuestionGridWithTotal' for single table inheritance (STI)
# :content      - questions
# :total_cols    - Which column(s) of the grid should be used for totals
require 'active_support/concern'
require 'qe/concerns/models/question_grid'

module Qe::Concerns::Models::QuestionGridWithTotal
	extend ActiveSupport::Concern
	include Qe::Concerns::Models::QuestionGrid
end
