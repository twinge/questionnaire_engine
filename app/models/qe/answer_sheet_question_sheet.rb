module Qe
	class AnswerSheetQuestionSheet < ActiveRecord::Base
   
    module M
      extend ActiveSupport::Concern
    
      included do
        belongs_to :answer_sheet, class_name: 'Qe::AnswerSheet'
        belongs_to :question_sheet, class_name: 'Qe::QuestionSheet'

        attr_accessible :answer_sheet, :question_sheet
      end
    end

   include M
 end
end
