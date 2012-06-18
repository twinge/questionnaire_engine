module Qe
  class AnswerSheet < ActiveRecord::Base
    set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"

    has_many :answer_sheet_question_sheets
    has_many :question_sheets, :through => :answer_sheet_question_sheets
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
    def question_sheet
      question_sheets.first
    end
    
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
      num_questions = 0
      question_sheets.each { |qs| num_questions += qs.questions.length }

      return 0 if num_questions == 0
      num_answers = answers.where("value IS NOT NULL && value != ''").select("DISTINCT question_id").count
      if [ [ (num_answers.to_f / num_questions.to_f * 100.0).to_i, 100 ].min, 0 ].max == 100 && !complete? 
        return 99
      else
        return [ [ (num_answers.to_f / num_questions.to_f * 100.0).to_i, 100 ].min, 0 ].max
      end
    end

    def collat_title() 
      "" 
    end
  
  end
end