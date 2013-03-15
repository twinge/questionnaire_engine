# == Schema Information
#
# Table name: qe_elements
#
#  id                 :integer          not null, primary key
#  question_grid_id   :integer
#  kind               :string(40)       not null
#  style              :string(40)
#  label              :string(255)
#  content            :text
#  required           :boolean
#  slug               :string(36)
#  position           :integer
#  object_name        :string(255)
#  attribute_name     :string(255)
#  source             :string(255)
#  value_xpath        :string(255)
#  text_path          :string(255)
#  cols               :string(255)
#  is_confidential    :boolean          default(FALSE)
#  total_cols         :string(255)
#  css_id             :string(255)
#  css_class          :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question_sheet_id  :integer
#  conditional_id     :integer
#  tooltip            :text
#  hide_label         :boolean          default(FALSE)
#  hide_option_labels :boolean          default(FALSE)
#  max_length         :integer
#

module Qe
  class Element < ActiveRecord::Base
    
    module ElementModule
      extend ActiveSupport::Concern
      included do 
        self.inheritance_column = :kind

        has_many :page_elements
        has_many :pages, through: :page_elements, dependent: :destroy, order: :position
        belongs_to :question_sheet

        validates_presence_of :label #, on: :update
        validates_presence_of :style #, on: :update

        KINDS = %w(Qe::Question)
        
        validates_inclusion_of :kind, :in => KINDS
      end


      def has_response?(answer_sheet = nil)
        false
      end
      
      def required?(answer_sheet = nil)
        super()
      end
      
      def position(page = nil)
        if page
          page_elements.where(:page_id => page.id).first.try(:position)
        else
          position
        end
      end
      
      def set_position(position, page = nil)
        if page
          pe = page_elements.where(:page_id => page.id).first
          pe.update_attribute(:position, position) if pe
        else
          self.position = position
        end
        position
      end
      
      def question?
        self.kind_of?(Qe::Question)
      end
      
      # by default the partial for an element matches the class name (override as necessary)
      def ptemplate
        self.class.to_s.underscore
      end
      
      # copy an item and all it's children
      def duplicate(page, parent = nil)

        # remove the id, so db table has only 1 primary key
        attributes = self.attributes
        attributes[:id] = nil

        new_element = self.class.new(attributes)

        case parent.class.to_s
                              when Qe::ChoiceField
                                new_element.conditional_id = parent.id
                              when Qe::QuestionGrid, Qe::QuestionGridWithTotal
                                new_element.question_grid_id = parent.id
                              end
        new_element.save(:validate => false)
        Qe::PageElement.create(:element => new_element, :page => page) unless parent
        
        # duplicate children
        if respond_to?(:elements) && elements.present?
          elements.each {|e| e.duplicate(page, new_element)}
        end
        
        new_element
      end
      
      # include nested elements
      def all_elements
        if respond_to?(:elements)
          (elements + elements.collect(&:all_elements)).flatten
        else
          []
        end
      end
      
      def reuseable?
        (self.is_a?(Qe::Question) || self.is_a?(Qe::QuestionGrid) || self.is_a?(Qe::QuestionGridWithTotal))
      end

      protected
      
      def set_defaults
        if self.content.blank?
          case self.class.to_s.demodulize
            when "ChoiceField" then self.content ||= "Choice One\nChoice Two\nChoice Three"
            when "Paragraph" then self.content ||="Lorem ipsum..." 
          end 
        end

        if self.style.blank?
          case self.class.to_s
          when 'TextField'              then self.style ||= 'qe/essay'
          when 'DateField'              then self.style ||= 'qe/date'
          when 'FileField'              then self.style ||= 'qe/file'
          when 'Paragraph'              then self.style ||= 'qe/paragraph'
          when 'Section'                then self.style ||= 'qe/section'
          when 'ChoiceField'            then self.style ||= 'qe/checkbox'
          when 'QuestionGrid'           then self.style ||= 'qe/grid'
          when 'QuestionGridWithTotal'  then self.style ||= 'qe/grid_with_total'
          when 'SchoolPicker'           then self.style ||= 'qe/school_picker'
          when 'ProjectPreference'      then self.style ||= 'qe/project_preference'
          when 'StateChooser'           then self.style ||= 'qe/state_chooser'
          when 'ReferenceQuestion'      then self.style ||= 'qe/peer'
        else
          self.style ||= self.class.to_s.underscore
          end 
        end
      end
    end # ElementModule

    include ElementModule
  end
end
