# Element represents a section, question or content element on the question sheet
class Element < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  belongs_to :question_grid, :class_name => "QuestionGrid", :foreign_key => "question_grid_id"
  
  self.inheritance_column = :kind
  
  belongs_to :page
  belongs_to :question_sheet
  
  acts_as_list :scope => :page_id

  validates_presence_of :kind
  validates_presence_of :label, :style, :on => :update
  
  validates_length_of :kind, :style, :maximum => 40, :allow_nil => true
  validates_length_of :label, :maximum => 255, :allow_nil => true

  # TODO: This needs to get abstracted out to a CustomQuestion class in BOAT
  validates_inclusion_of :kind, :in => %w{Section Paragraph TextField ChoiceField DateField FileField SchoolPicker ProjectPreference StateChooser QuestionGrid}  # leaf classes
  
  before_create :set_defaults
  
  HUMANIZED_ATTRIBUTES = {
    :slug => "Variable"
  }
    
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  
  def question?
    self.kind_of?(Question)
  end
  
  
  # by default the partial for an element matches the class name (override as necessary)
  def template
    self.class.to_s.underscore
  end
  
  protected
  def set_defaults
    self.label = "Untitled" if label.nil?
    if self.content.nil?
      case self.class.to_s
        when "ChoiceField" then self.content = "Choice One\nChoice Two\nChoice Three"
        when "Paragraph" then self.content ="Lorem ipsum..." 
      end 
    end

    if self.style.nil?
      case self.class.to_s
        when "DateField" then self.style = "date"
        when "FileField" then self.style = "file"
        when "Paragraph" then self.style = "paragraph"
        when "Section" then self.style = "section"
        # TODO: This needs to get abstracted out to a CustomQuestion class in BOAT
        when "QuestionGrid" then self.style = "grid"
        when "SchoolPicker" then self.style = "school_picker"
        when "ProjectPreference" then self.style = "project_preference"
        when "StateChooser" then self.style = "state_chooser"
      end 
    end
  end
    
end
