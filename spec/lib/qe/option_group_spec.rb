require 'spec_helper'

describe Qe::OptionGroup do 

  let(:subject) { Qe::OptionGroup.new('some label', 'some group') }

  it { subject.label.should == 'some label' }
  it { subject.group.should == 'some group' }
end