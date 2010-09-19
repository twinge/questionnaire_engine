class PageElement < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  acts_as_list :scope => :page_id
  belongs_to :page
  belongs_to :element
end
