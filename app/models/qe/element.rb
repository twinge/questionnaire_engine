module Qe
  class Element < ActiveRecord::Base
    has_many :page_elements #, :class_name => Qe::PageElement, :foreign_key => :qe_element_id
    has_many :pages, :through => :page_elements, :dependent => :destroy, :order => :position
    belongs_to :question_sheet
  end
end
