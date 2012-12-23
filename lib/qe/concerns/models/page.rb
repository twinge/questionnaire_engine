module Qe
  module Concerns
    module Models
      module Page

        extend ActiveSupport::Concern

        included do
          has_many :qe_page_elements,
            :class_name => Qe::PageElement,
            :foreign_key => :qe_page_id

          has_many :qe_elements,
            :through => :qe_page_elements,
            :dependent => :destroy,
            :order => :position

          belongs_to :qe_question_sheet
        end

      end
    end
  end
end
