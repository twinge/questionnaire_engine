# QuestionSheet represents a particular form
class QuestionSheet < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  
  has_many :pages, :dependent => :destroy, :order => 'number'
  has_many :elements
  has_many :answer_sheets
  
  validates_presence_of :label
  validates_length_of :label, :maximum => 60, :allow_nil => true  
  validates_uniqueness_of :label

  
  # create a new form with a page already attached
  def self.new_with_page
    question_sheet = self.new(:label => next_label)
    question_sheet.pages.build(:label => 'Page 1', :number => 1)    
    question_sheet
  end
 
  
  
  private
  
  # next unused label with "Untitled form" prefix
  def self.next_label
    ModelExtensions.next_label("Untitled form", untitled_labels)
  end

  # returns a list of existing Untitled forms
  # (having a separate method makes it easy to mock in the spec)
  def self.untitled_labels
    QuestionSheet.find(:all, :conditions => %{label like 'Untitled form%'}).map {|s| s.label}
  end

end
