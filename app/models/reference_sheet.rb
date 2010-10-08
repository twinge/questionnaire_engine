class ReferenceSheet < AnswerSheet
  set_table_name "#{Questionnaire.table_name_prefix}references"
  belongs_to :response
  
  belongs_to :question
  belongs_to :applicant_answer_sheet, :class_name => "AnswerSheet", :foreign_key => "applicant_answer_sheet_id"
end

