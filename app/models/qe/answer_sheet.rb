module Qe
  class AnswerSheet < ActiveRecord::Base
    belongs_to :question_sheet
  end
end
