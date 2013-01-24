module Qe
  class QuestionSheet < ActiveRecord::Base
    has_many :pages
    has_many :conditions

    attr_accessible :label
  end
end

