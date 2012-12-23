module Qe
  class Question < ActiveRecord::Base
    included Qe::Concerns::Models::Question
  end
end
