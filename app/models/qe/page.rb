# == Schema Information
#
# Table name: qe_pages
#
#  id                :integer          not null, primary key
#  question_sheet_id :integer          not null
#  label             :string(60)       not null
#  number            :integer
#  no_cache          :boolean          default(FALSE)
#  hidden            :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Qe
  class Page < ActiveRecord::Base

    belongs_to :question_sheet

    has_many :page_elements
    has_many :elements, through: :page_elements, order: Qe::PageElement.table_name + '.position', dependent: :destroy
    has_many :questions, through: :page_elements, :conditions => "kind NOT IN('Qe::Paragraph', 'Qe::Section', 'Qe::QuestionGrid', 'Qe::QuestionGridWithTotal')", :source => :element
    has_many :conditions, class_name: Qe::Condition.name, :foreign_key => "toggle_page_id", conditions: 'toggle_id IS NOT NULL', dependent: :nullify
    # has_many :question_grid_with_totals, through: :page_elements, :conditions => "kind = 'Qe::QuestionGridWithTotal'", :source => :element
    # has_many :question_grids, :through => :page_elements, :conditions => "kind = 'Qe::QuestionGrid'", :source => :element


    # acts_as_list :column => :number, :scope => :question_sheet
    
    scope :visible, :conditions => {:hidden => false}
    
    before_validation :set_default_label, :on => :create    # Page x
    
    validates_presence_of     :label,   :number
    validates_length_of       :label,   :maximum => 100, :allow_nil => true
    validates_uniqueness_of   :number,  :scope => :question_sheet_id
    validates_numericality_of :number,  :only_integer => true
    
    attr_accessible :label, :number, :page, :id, :question_sheet_id, 
                    :no_cache, :hidden, :updated_at, :created_at


    # a page is disabled if there is a condition, and that condition evaluates to false
    # could set multiple conditions to influence this question, in which case all must be met
    # def active?
    #   # find first condition that doesn't pass (nil if all pass)
    #   self.conditions.detect { |c| !c.evaluate? }.nil?  # true if all pass
    # end
    #   
    # def question?
    #   false
    # end

    def questions_before_position(position)
      elements.where(["#{Qe::PageElement.table_name}.position < ?", position])
    end
    
    # Include nested elements
    def all_elements
      (elements + elements.collect(&:all_elements)).flatten
    end
    
    # Called by QuestionSheet#duplicate for recursive copy action.
    def copy_to(question_sheet)
      # sets id, the primary key, to nil. assigned on
      attributes = self.attributes
      attributes[:id] = nil
      attributes.delete(:updated_at)
      attributes.delete(:created_at)

      # clear_unique_attributes = Hash.new(:updated_at => nil, :created_at => nil, :id => nil)      
      # cloned_attributes = self.attributes.merge(clear_unique_attributes)

      new_page = Qe::Page.new(attributes)
      new_page.question_sheet_id = question_sheet.id
      new_page.save(:validate => false)
      self.elements.each do |element|
        
        if !question_sheet.archived? && element.reuseable?
          
          set_time_nil = Hash.new(:created_at => nil, :updated_at => nil)
          cloned_attributes = element.attributes.merge(set_time_nil)
          element.attributes = cloned_attributes
          Qe::PageElement.create!(:element => element, :page => new_page)
        
        else
          element.duplicate(new_page)
        end
      end
    end
    
    def complete?(answer_sheet)
      all_elements.all? {|e| !e.required?(answer_sheet) || e.has_response?(answer_sheet)}
    end
    
    def started?(answer_sheet)
      all_elements.any? {|e| e.has_response?(answer_sheet)}
    end
    
    def has_questions?
      all_elements.any? {|e| e.is_a?(Qe::Question)}
    end



    private
    def set_default_label
      self.label = Qe::ModelExtensions.next_label("Page", Qe::Page.untitled_labels(self.question_sheet)) if self.label.blank?
    end
    
    def self.untitled_labels(sheet)
      sheet ? sheet.pages.where("label like 'Page %'").map {|p| p.label} : []
    end

  end
end
