class AnswerSheet < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"

  has_many :answer_sheet_question_sheets
  has_many :question_sheets, :through => :answer_sheet_question_sheets
  has_many :answers, :dependent => :delete_all

  def complete?
    !completed_at.nil?
  end
  
  # answers for this sheet, grouped by question id
  def answers_by_question
    self.answers.find(:all).group_by { |answer| answer.question_id }
  end
  
  # Convenience method if there is only one question sheet in your system
  def question_sheet
    question_sheets.first
  end
  
  def pages
    Page.where(:question_sheet_id => question_sheets.collect(&:id))
  end
   
end
