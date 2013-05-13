module Qe
	class AnswerSheetQuestionSheet < ActiveRecord::Base
   
    module M
      extend ActiveSupport::Concern
    
      included do
        belongs_to :answer_sheet
        belongs_to :question_sheet
      end
    end

   include M
 end
end
