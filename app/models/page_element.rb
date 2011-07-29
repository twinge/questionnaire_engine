class PageElement < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  acts_as_list :scope => :page_id
  belongs_to :page
  belongs_to :element
  belongs_to :question, :conditions => "kind NOT IN('Paragraph', 'Section', 'QuestionGrid', 'QuestionGridWithTotal')", :foreign_key => 'element_id', :class_name => 'Element'
end
