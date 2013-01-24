module Qe
  class AnswerSheet < ActiveRecord::Base
    belongs_to :question_sheet
    has_many :reference_sheets, 
      foreign_key: 'applicant_answer_sheet_id'
  end
end
