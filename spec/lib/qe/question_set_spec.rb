require 'spec_helper'

describe Qe::QuestionSet do 
  let(:subject) { Qe::QuestionSet.new('arg_elements', 'arg_answer_sheets') }  
  
  # TODO initialize method requires objects to be related 
  xit { should respond_to :elements }

  xit '#post'
  xit '#any_questions?'
  xit '#save'
  xit '#post_values'
end