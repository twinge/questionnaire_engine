require 'spec_helper' 

describe Qe::QuestionGrid do 
  it { should have_many :elements }
  it { should have_many :first_level_questions }
end
