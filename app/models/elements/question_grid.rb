# QuestionGrid
# - Represents a grid layout of a set of questions
#
# :kind         - 'QuestionGrid' for single table inheritance (STI)
# :content      - questions

class QuestionGrid < Element

 has_many :elements, :class_name => "Element", :foreign_key => "question_grid_id", :dependent => :nullify, :order => :position
 
  def num_cols
    cols.split(';').length
  end
end
