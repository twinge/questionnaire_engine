# WARNING
# without requiring Qe::Element, all inheriting models do not work
require 'qe/element' 

module Qe
  class Question < Element
    include Qe::Concerns::Models::Question
  end
end
