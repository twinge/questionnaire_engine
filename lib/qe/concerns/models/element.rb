module Qe
  module Concerns
    module Models
      module Element

        extend ActiveSupport::Concern

        included do
          has_many :qe_page_elements,
            :class_name => Qe::PageElement,
            :foreign_key => :qe_element_id

          has_many :qe_pages,
            :through => :qe_page_elements,
            :dependent => :destroy,
            :order => :position

          belongs_to :qe_question_sheet
        end

      end
    end
  end
end
