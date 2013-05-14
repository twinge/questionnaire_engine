require 'spec_helper'

describe Qe::Option do
  let(:subject) { Qe::Option.new(:some_key, 'some value') }

  it { subject.key.should == :some_key }
  it { subject.value.should == 'some value' }
end
