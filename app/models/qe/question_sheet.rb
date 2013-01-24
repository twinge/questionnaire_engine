module Qe
  class QuestionSheet < ActiveRecord::Base
    has_many :pages
    has_many :conditions
    has_many :questions,
      foreign_key: 'related_question_sheet_id'


    attr_accessible :label
  end
end

