module Qe::Concerns::Models
	module AnswerSheetQuestionSheet
		extend ActiveSupport::Concern
		
		included do
		  # self.table_name = "#{self.table_name}"
		  belongs_to :answer_sheet
		  belongs_to :question_sheet

		  attr_accessible :answer_sheet, :question_sheet
		end
		
	end
end