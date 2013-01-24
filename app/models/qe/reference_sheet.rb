module Qe
  class ReferenceSheet < ActiveRecord::Base
    
    # belongs_to :question, :class_name => Qe::Element, :foreign_key => 'question_id'
    # belongs_to :question, :class_name => Qe::Element, :foreign_key => 'question_id'
    belongs_to :applicant_answer_sheet, 
      :class_name => Qe::AnswerSheet, 
      :foreign_key => 'applicant_answer_sheet_id'

  end
end
