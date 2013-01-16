module Qe
  class QuestionSheet < ActiveRecord::Base
    has_many :pages, :class_name => 'Qe::Page'
    has_many :conditions

    attr_accessible :label
  end
end

