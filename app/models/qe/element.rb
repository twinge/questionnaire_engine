module Qe
  class Element < ActiveRecord::Base
    
    self.inheritance_column = :kind

    has_many :page_elements
    has_many :pages, 
      :through => :page_elements, 
      :dependent => :destroy, 
      :order => :position
    belongs_to :question_sheet

    validates_presence_of :label #, on: :update
    validates_presence_of :style #, on: :update

    KINDS = %w(Qe::Question Qe)
    
    validates_inclusion_of :kind, 
      :in => KINDS

  end
end
