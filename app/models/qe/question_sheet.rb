# should be required from lib/qe.rb
# require 'qe/model_extensions'

# QuestionSheet represents a particular form
module Qe
  class QuestionSheet < ActiveRecord::Base
    include Qe::Concerns::Models::QuestionSheet
  end
end
