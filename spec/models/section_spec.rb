require 'spec_helper'

describe Qe::Section do 
  it 'should inherit from Qe::Element' do 
    Qe::Section.superclass.should be(Qe::Element)
  end
end
