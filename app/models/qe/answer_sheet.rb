# == Schema Information
#
# Table name: qe_answer_sheets
#
#  id                :integer          not null, primary key
#  question_sheet_id :integer          not null
#  completed_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Qe
  class AnswerSheet < ActiveRecord::Base
    
    module M
      extend ActiveSupport::Concern
      included do 
        belongs_to :question_sheet
        has_many :reference_sheets, foreign_key: 'applicant_answer_sheet_id'
        has_many :answers
        has_many :reference_sheets, :foreign_key => 'applicant_answer_sheet_id'
        
        attr_accessible :question_sheet_id, :label
      end

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
        Qe::Page.where(:question_sheet_id => question_sheets.collect(&:id))
      end
      
      def completely_filled_out?
        pages.all? {|p| p.complete?(self)}
      end
      
      def has_answer_for?(question_id)
        !answers_by_question[question_id].nil?
      end
      
      def reference?
        return false
      end
       
      def count_answers
        answers.where("value IS NOT NULL != ''").select("DISTINCT question_id").count
      end

      def count_questions
        num_questions = 0
        question_sheets.each do |qs|
          num_questions = qs.elements.count + num_questions
        end
        num_questions
      end

      def percent_complete
        # num_questions = count_questions
        # return 0 if num_questions == 0
        # num_answers = count_answers
        # if [ [ (num_answers.to_f / num_questions.to_f * 100.0).to_i, 100 ].min, 0 ].max == 100 && !complete? 
        #   return 99
        # else
        #   return [ [ (num_answers.to_f / num_questions.to_f * 100.0).to_i, 100 ].min, 0 ].max
        # end
        100
      end

      def collat_title
        "" 
      end
    end

    include M
  end
end
