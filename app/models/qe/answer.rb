module Qe
  class Answer < ActiveRecord::Base
    
    module M
      extend ActiveSupport::Concern
      include ActionView::Helpers::TextHelper   # bleh

      included do
        belongs_to :answer_sheet
        belongs_to :question, :foreign_key => "question_id"
        
        validates_presence_of :value
        validates_length_of :short_value, :maximum => 255, :allow_nil => true  
        
        before_save :set_value_from_filename

        attr_accessible :answer_sheet, :question, :value, :question_id
      end
      
      def set(value, short_value = value)
        self.value = value
        self.short_value = truncate(short_value, :length => 225) # adds ... if truncated (but not if not)
      end
      
      def to_s
        self.value
      end
      
      def set_value_from_filename
        self.value = self.short_value = self.attachment_file_name if self[:attachment_file_name].present?
      end
    end

    include M
  end
end
