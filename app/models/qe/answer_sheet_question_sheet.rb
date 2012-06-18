module Qe
	class AnswerSheetQuestionSheet < ActiveRecord::Base
	  set_table_name "#{self.table_name}"
	  belongs_to :qe_answer_sheet
	  belongs_to :qe_question_sheet
	end
end