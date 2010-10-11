class AnswerSheetQuestionSheet < ActiveRecord::Base
  belongs_to :answer_sheet
  belongs_to :question_sheet
end
