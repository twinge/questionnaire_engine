# this should be taken care of via lib/qe.rb
# 
# require 'net/http'
# begin
#   require 'xml/libxml'
# rescue LoadError
#   require 'rexml/document'
# end

# ChoiceField
# - a question that allows the selection of one or more choices

module Qe
  class ChoiceField < Question
    include Qe::Concerns::Models::ChoiceField
  end
end
