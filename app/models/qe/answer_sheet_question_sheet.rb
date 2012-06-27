module Qe
	class AnswerSheetQuestionSheet < ActiveRecord::Base
	  # self.table_name = "#{self.table_name}"
	  belongs_to :answer_sheet
	  belongs_to :question_sheet
	end
end