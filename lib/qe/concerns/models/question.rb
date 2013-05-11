# require 'qe/concerns/models/element'
# Question
# - An individual question element
# - children: TextField, ChoiceField, DateField, FileField

# :kind         - 'TextField', 'ChoiceField', 'DateField' for single table inheritance (STI)
# :label        - label for the question, such as "First name"
# :style        - essay|phone|email|numeric|currency|simple, selectbox|radio, checkbox, my|mdy
# :required     - is this question itself required or optional?
# :content      - choices (one per line) for choice field


module Qe
  module Concerns
    module Models
      module Question

      end
    end
  end
end

