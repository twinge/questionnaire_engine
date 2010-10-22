require 'model_extensions'
class Page < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  
  belongs_to :question_sheet
  has_many :page_elements, :dependent => :destroy, :order => :position
  has_many :elements, :through => :page_elements, :order => PageElement.table_name + '.position'
  has_many :question_grid_with_totals, :through => :page_elements, :conditions => "kind = 'QuestionGridWithTotal'", :source => :element
  has_many :questions, :through => :page_elements, :conditions => "kind NOT IN('Paragraph', 'Section', 'QuestionGrid', 'QuestionGridWithTotal')", :source => :element
  has_many :question_grids, :through => :page_elements, :conditions => "kind = 'QuestionGrid'", :source => :element
  has_many :conditions, :class_name => "Condition", :foreign_key => "toggle_page_id",   # conditions associated with page as a whole
          :conditions => 'toggle_id is NULL', :dependent => :nullify
  
  acts_as_list :column => :number, :scope => :question_sheet_id
  
  scope :visible, :conditions => {:hidden => false}
  
  # callbacks
  before_validation :set_default_label, :on => :create    # Page x
  
  # validation
  validates_presence_of :label, :number
  validates_length_of :label, :maximum => 100, :allow_nil => true
  
  # validates_uniqueness_of :number, :scope => :question_sheet_id
     
  validates_numericality_of :number, :only_integer => true
    
  # a page is disabled if there is a condition, and that condition evaluates to false
  # could set multiple conditions to influence this question, in which case all must be met
  def active?
    # find first condition that doesn't pass (nil if all pass)
    self.conditions.detect { |c| !c.evaluate? }.nil?  # true if all pass
  end
    
  def question?
    false
  end

  def questions_before_position(position)
    self.elements.where(["#{PageElement.table_name}.position < ?", position])
  end
  
  # Include nested elements
  def all_elements
    (elements + elements.collect(&:all_elements)).flatten
  end
  
  def copy_to(question_sheet)
    new_page = Page.new(self.attributes)
    new_page.question_sheet_id = question_sheet.id
    new_page.save(:validate => false)
    self.elements.each do |element|
      if !question_sheet.archived? && element.reuseable?
        PageElement.create(:element => element, :page => new_page)
      else
        element.duplicate(new_page)
      end
    end
  end
  
  
  private
  
  # next unused label with "Page" prefix
  def set_default_label
    self.label = ModelExtensions.next_label("Page", Page.untitled_labels(self.question_sheet)) if self.label.blank?
  end
  
  def self.untitled_labels(sheet)
    sheet ? sheet.pages.where("label like 'Page %'").map {|p| p.label} : []
  end

end
