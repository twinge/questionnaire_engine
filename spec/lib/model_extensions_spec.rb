require File.dirname(__FILE__) + '/../spec_helper'

require 'model_extensions'

describe "next_label" do
  include ModelExtensions
  
  it "should return 1 when no labels present" do
    next_label("Prefix", []).should == "Prefix 1"
  end
  
  it "should return the next one" do
    existing = ["Prefix 1"]
    next_label("Prefix", existing).should == "Prefix 2"
  end

  it "should return one greater than the highest" do
    existing = ["Prefix 13", "Prefix 40"]
    next_label("Prefix", existing).should == "Prefix 41"
  end
  
  it "should ignore labels without a number" do
    existing = ["Prefix A"]
    next_label("Prefix", existing).should == "Prefix 1"
  end
  
end