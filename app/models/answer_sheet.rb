class AnswerSheet < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"

  belongs_to :question_sheet
  has_many :answers, :dependent => :delete_all
  has_one Questionnaire.answer_sheet_has_one, :dependent => :destroy unless Questionnaire.answer_sheet_has_one.nil?

  def complete?
    !completed_at.nil?
  end
  
  # answers for this sheet, grouped by question id
  def answers_by_question
    self.answers.find(:all).group_by { |answer| answer.question_id }
  end
   
end
