# Element represents a section, question or content element on the question sheet

module Qe
  module Concerns
    module Models
      module Element

        extend ActiveSupport::Concern

        included do
          self.inheritance_column = :kind

          belongs_to :question_sheet
          belongs_to :question_grids, :foreign_key => "question_grid_id"
          belongs_to :choice_fields, :foreign_key => "conditional_id"
          
          has_many :page_elements, :dependent => :destroy
          has_many :pages, :through => :page_elements
          
          # TODO rework with namespacing.
          scope :active, select("distinct(#{Qe.table_name_prefix}elements.id), #{Qe.table_name_prefix}elements.*").where(Qe::QuestionSheet.table_name + '.archived' => false).joins({:pages => :question_sheet})

          validates_presence_of :label, :style, :on => :update
          
          validates_length_of :kind, :style, :maximum => 40, :allow_nil => true

          # TODO (added before put in gem form): 
          # This needs to get abstracted out to a CustomQuestion class in BOAT
          validates_inclusion_of :kind, :in => %w{
          Qe::Section 
          Qe::Paragraph 
          Qe::TextField 
          Qe::ChoiceField 
          Qe::DateField 
          Qe::FileField 
          Qe::SchoolPicker 
          Qe::ProjectPreference 
          Qe::StateChooser 
          Qe::QuestionGrid 
          Qe::QuestionGridWithTotal 
          Qe::AttachmentField 
          Qe::ReferenceQuestion 
          Qe::PaymentQuestion
          }  # leaf classes
          
          before_validation :set_defaults, :on => :create
          
          attr_accessible :attribute_name, 
                          :cols, 
                          :conditional_id, 
                          :content, 
                          :created_at, 
                          :css_class, 
                          :css_id, 
                          :hide_label, 
                          :hide_option_labels, 
                          :is_confidential, 
                          :kind, 
                          :label, 
                          :max_length, 
                          :no_cache, 
                          :object_name, 
                          :position, 
                          :question_grid_id, 
                          :related_question_sheet_id, 
                          :required, 
                          :slug, 
                          :source, 
                          :style, 
                          :text_xpath, 
                          :tooltip, 
                          :total_cols, 
                          :updated_at, 
                          :value_xpath,
                          :element, 
                          :text_path, 
                          :question_sheet_id
        

          # HUMANIZED_ATTRIBUTES = {
          #   :slug => "Variable"
          # }
          #   
          # def self.human_attrib_name(attr)
          #   HUMANIZED_ATTRIBUTES[attr.to_sym] || super
          # end
        
            
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
              self[:position]
            end
          end
          
          def set_position(position, page = nil)
            if page
              pe = page_elements.where(:page_id => page.id).first
              pe.update_attribute(:position, position) if pe
            else
              self[:position] = position
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
              when 'TextField' then self.style ||= 'qe/essay'
              when 'DateField' then self.style ||= 'qe/date'
              when 'FileField' then self.style ||= 'qe/file'
              when 'Paragraph' then self.style ||= 'qe/paragraph'
              when 'Section' then self.style ||= 'qe/section'
              when 'ChoiceField' then self.style = 'qe/checkbox'
              when 'QuestionGrid' then self.style ||= 'qe/grid'
              when 'QuestionGridWithTotal' then self.style ||= 'qe/grid_with_total'
              when 'SchoolPicker' then self.style ||= 'qe/school_picker'
              when 'ProjectPreference' then self.style ||= 'qe/project_preference'
              when 'StateChooser' then self.style ||= 'qe/state_chooser'
              when 'ReferenceQuestion' then self.style ||= 'qe/peer'
              else
                self.style ||= self.class.to_s.underscore
              end 
            end
          end
        end

        module ClassMethods
          def max_label_length
            @@max_label_length ||= Qe::Element.columns.find{ |c| c.name == "label" }.limit
          end
        end

      end
    end
  end
end