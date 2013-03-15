# == Schema Information
#
# Table name: qe_answers
#
#  id                      :integer          not null, primary key
#  answer_sheet_id         :integer          not null
#  question_id             :integer          not null
#  value                   :text
#  short_value             :string(255)
#  attachment_file_size    :integer
#  attachment_content_type :string(255)
#  attachment_file_name    :string(255)
#  attachment_updated_at   :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

module Qe
  class Answer < ActiveRecord::Base

    module AnswerModule
      extend ActiveSupport::Concern
      included do 
        belongs_to :answer_sheet
        belongs_to :question

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
        value = short_value = attachment_file_name if attachment_file_name.present?
      end
    end # include AnswerModule

    include AnswerModule
  end
end
