module Qe::Concerns::Models
	module AnswerSheetQuestionSheet
		extend ActiveSupport::Concern
		
		included do
		  belongs_to :answer_sheet
		  belongs_to :question_sheet

		  attr_accessible :answer_sheet, :question_sheet
		end
		
	end
end