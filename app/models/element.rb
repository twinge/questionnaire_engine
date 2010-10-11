# Element represents a section, question or content element on the question sheet
class Element < ActiveRecord::Base
  set_table_name "#{Questionnaire.table_name_prefix}#{self.table_name}"
  belongs_to :question_grid, :class_name => "QuestionGrid", :foreign_key => "question_grid_id"
  belongs_to :choice_field, :class_name => "ChoiceField", :foreign_key => "conditional_id"
  
  self.inheritance_column = :kind
  
  has_many :page_elements, :dependent => :destroy
  has_many :pages, :through => :page_elements
  
  # belongs_to :question_sheet

  validates_presence_of :kind, :style
  # validates_presence_of :label, :style, :on => :update
  
  validates_length_of :kind, :style, :maximum => 40, :allow_nil => true
  validates_length_of :label, :maximum => 255, :allow_nil => true

  # TODO: This needs to get abstracted out to a CustomQuestion class in BOAT
  validates_inclusion_of :kind, :in => %w{Section Paragraph TextField ChoiceField DateField FileField SchoolPicker ProjectPreference StateChooser QuestionGrid QuestionGridWithTotal AttachmentField ReferenceQuestion}  # leaf classes
  
  before_validation :set_defaults, :on => :create
  
  # HUMANIZED_ATTRIBUTES = {
  #   :slug => "Variable"
  # }
  #   
  # def self.human_attrib_name(attr)
  #   HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  # end
  
  def position(page)
    page_elements.where(:page_id => page.id).first.try(:position)
  end
  
  def set_position(position, page)
    pe = page_elements.where(:page_id => page.id).first
    pe.update_attribute(:position, position) if pe
    position
  end
  
  def question?
    self.kind_of?(Question)
  end
  
  
  # by default the partial for an element matches the class name (override as necessary)
  def ptemplate
    self.class.to_s.underscore
  end
  
  # copy an item and all it's children
  def duplicate(page, grid_id = nil)
    new_element = self.class.new(self.attributes)
    new_element.question_grid_id = grid_id if grid_id
    new_element.save!
    PageElement.create(:element => new_element, :page => page)
    
    # duplicate children
    if respond_to?(:elements) && elements.present?
      elements.each {|e| e.duplicate(page, new_element.id)}
    end
    
    new_element
  end
  
  protected
  def set_defaults
    self.label = "Untitled" if label.nil?
    if self.content.nil?
      case self.class.to_s
        when "ChoiceField" then self.content ||= "Choice One\nChoice Two\nChoice Three"
        when "Paragraph" then self.content ||="Lorem ipsum..." 
      end 
    end

    if self.style.nil?
      case self.class.to_s
        when "DateField" then self.style ||= "date"
        when "FileField" then self.style ||= "file"
        when "Paragraph" then self.style ||= "paragraph"
        when "Section" then self.style ||= "section"
        # when "ChoiceField" then self.style = "checkbox"
        when "QuestionGrid" then self.style ||= "grid"
        when "QuestionGridWithTotal" then self.style ||= "grid_with_total"
        when "SchoolPicker" then self.style ||= "school_picker"
        when "ProjectPreference" then self.style ||= "project_preference"
        when "StateChooser" then self.style ||= "state_chooser"
        when "ReferenceQuestion" then self.style ||= "peer"
      end 
    end
  end
    
end
