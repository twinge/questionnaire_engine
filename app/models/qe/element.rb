module Qe
  class Element < ActiveRecord::Base
    has_many :page_elements
    has_many :pages, 
      :through => :page_elements, 
      :dependent => :destroy, 
      :order => :position
    belongs_to :question_sheet
  end
end
