module Qe
  class Quesiton < Element

    has_many :sheet_answers, 
      :class_name => Qe::Answer, 
      :dependent => :destroy
    belongs_to :related_question_sheet, 
      :class_name => Qe::QuestionSheet, 
      :foreign_key => "related_question_sheet_id"
      
  end
end
