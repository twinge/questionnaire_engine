module Qe
  class Condition < ActiveRecord::Base
    belongs_to :question_sheet
  end
end
