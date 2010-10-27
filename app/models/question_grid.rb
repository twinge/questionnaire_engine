# QuestionGrid
# - Represents a grid layout of a set of questions
#
# :kind         - 'QuestionGrid' for single table inheritance (STI)
# :content      - questions

class QuestionGrid < Element

 has_many :elements, :class_name => "Element", :foreign_key => "question_grid_id", :dependent => :nullify, :order => :position
 
  def num_cols
    num = cols.to_s.split(';').length
    num = 1 if num == 0
    num
  end
  
  def has_response?(answer_sheet = nil)
    elements.any? {|e| e.has_response?(answer_sheet)}
  end
  
end
