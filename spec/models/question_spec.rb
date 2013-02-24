require 'spec_helper'

describe Qe::Question do 
  it { subject.class.superclass.should be(Qe::Element) }

  it { should belong_to :question_sheet }
  it { should have_many :answers }
  it { should have_many :conditions } 
end
