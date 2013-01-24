require 'spec_helper'

describe Qe::Question do 

  it { should belong_to :related_question_sheet }
  it { should have_many :sheet_answers } 
end
