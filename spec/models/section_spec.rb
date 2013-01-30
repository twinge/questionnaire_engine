require 'spec_helper'

describe Qe::Section do 
  it { subject.class.superclass.should be(Qe::Element) }
end
