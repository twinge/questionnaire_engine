require 'active_support/concerns'

module Qe::Conerns::Models::AnswerSheetQuestionSheet
	extend ActiveSupport::Concerns
	
	included do
	  # self.table_name = "#{self.table_name}"
	  belongs_to :answer_sheet
	  belongs_to :question_sheet
	end
end