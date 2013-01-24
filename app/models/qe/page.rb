module Qe
  class Page < ActiveRecord::Base
    has_many :page_elements
    has_many :elements, :through => :page_elements, :dependent => :destroy, :order => :position
    belongs_to :question_sheet
  end
end
