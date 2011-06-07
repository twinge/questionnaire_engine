class AnswerSheet < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"

  belongs_to :person
  belongs_to :question_sheet, :class_name => "QuestionSheet", :foreign_key => "question_sheet_id"
  has_many :answers, :class_name => 'Answer', :foreign_key => 'answer_sheet_id'
  has_many :reference_sheets, :class_name => "ReferenceSheet", :foreign_key => "applicant_answer_sheet_id"

  def complete?
    !completed_at.nil?
  end
  
  # answers for this sheet, grouped by question id
  def answers_by_question
    @answers_by_question ||= self.answers.find(:all).group_by { |answer| answer.question_id }
  end
  
  # Convenience method if there is only one question sheet in your system
  # def question_sheet
  #   question_sheets.first
  # end
  
  def pages
    Page.where(:question_sheet_id => question_sheets.collect(&:id))
  end
  
  def completely_filled_out?
    pages.all? {|p| p.complete?(self)}
  end
  
  def has_answer_for?(question_id)
    !answers_by_question[question_id].nil?
  end
  
  def reference?
    false
  end
   
  def percent_complete
    num_questions = question_sheets.inject(0.0) { |sum, qs| qs.nil? ? sum : qs.questions.length + sum }
    return 0 if num_questions == 0
    num_answers = answers.where("value IS NOT NULL && value != ''").select("DISTINCT question_id").count
    [ [ (num_answers.to_f / num_questions.to_f * 100.0).to_i, 100 ].min, 0 ].max
  end

  def collat_title() "" end
end
