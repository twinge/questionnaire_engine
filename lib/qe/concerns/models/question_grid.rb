# QuestionGrid
# - Represents a grid layout of a set of questions
#
# :kind         - 'QuestionGrid' for single table inheritance (STI)
# :content      - questions

module Qe::Concerns::Models::QuestionGrid
  extend ActiveSupport::Concern
  include Qe::Concerns::Models::Element

  included do
    has_many :elements, :foreign_key => "question_grid_id", :dependent => :nullify, :order => :position
    has_many :first_level_questions, :class_name => Qe::Element, :foreign_key => "question_grid_id", :conditions => "kind NOT IN('Paragraph', 'Qe::Section', 'Qe::QuestionGrid', 'Qe::QuestionGridWithTotal')"
  end

  def num_cols
    num = cols.to_s.split(';').length
    num = 1 if num == 0
    num
  end
  
  def has_response?(answer_sheet = nil)
    elements.any? {|e| e.has_response?(answer_sheet)}
  end

  def questions
    ret_val = first_level_questions
    elements.each do |e|
      if e.respond_to?(:questions)
        ret_val += e.questions
      end
    end
    ret_val
  end
end


# /admin/question_sheet/elements success
# admin_question_sheets GET    /admin/question_sheets(.:format)   qe/admin/question_sheets#index