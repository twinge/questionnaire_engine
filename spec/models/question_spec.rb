require 'spec_helper'

describe Qe::Question do 
  it { subject.class.superclass.should be(Qe::Element) }

  it { should belong_to :related_question_sheet }
  it { should have_many :sheet_answers } 
end
