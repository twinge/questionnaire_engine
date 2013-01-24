module Qe
  class Answer < ActiveRecord::Base
    belongs_to :answer_sheet
    belongs_to :question
  end
end
