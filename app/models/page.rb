class Page < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  
  belongs_to :question_sheet
  has_many :elements, :dependent => :destroy, :order => :position
  has_many :questions, :class_name => "Question", :foreign_key => "page_id"
  has_many :question_grids, :class_name => "QuestionGrid", :foreign_key => "page_id"
  has_many :conditions, :class_name => "Condition", :foreign_key => "toggle_page_id",   # conditions associated with page as a whole
          :conditions => 'toggle_id is NULL', :dependent => :nullify
  
  acts_as_list :column => :number, :scope => :question_sheet_id
  
  named_scope :visible, :conditions => {:hidden => false}
  
  # callbacks
  before_validation_on_create :set_default_label    # Page x
  
  # validation
  validates_presence_of :label, :number
  validates_length_of :label, :maximum => 100, :allow_nil => true
  
  validates_uniqueness_of :number, :scope => :question_sheet_id
     
  validates_numericality_of :number, :only_integer => true
    
  # a page is disabled if there is a condition, and that condition evaluates to false
  # could set multiple conditions to influence this question, in which case all must be met
  def active?
    # find first condition that doesn't pass (nil if all pass)
    self.conditions.find { |c| !c.evaluate? }.nil?  # true if all pass
  end
    
  def question?
    false
  end

  def questions_before_position(position)
    self.elements.find(:all, :conditions => ["position < ?", position])
  end
  
  
  private
  
  # next unused label with "Page" prefix
  def set_default_label
    self.label = ModelExtensions.next_label("Page", Page.untitled_labels(self.question_sheet)) if self.label.blank?
  end
  
  def self.untitled_labels(sheet)
    sheet.pages.find(:all, :conditions => %{label like 'Page %'}).map {|p| p.label}
  end

end
