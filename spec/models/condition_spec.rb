require File.dirname(__FILE__) + '/../spec_helper'

describe Condition do
  before(:each) do
    @condition = Condition.new
  end

  it "should be valid with a full set of valid attributes"
  
  it "should evaluate to true if the answer matches the expression"
  it "should evaluate to true if ANY of the answers matches the expression (choose many)"
  it "should evaluate to false if the answer is blank"
  it "should evaluate to false if the triggering question is inactive due to its' conditions"
  
  it "should provide a list of pages dependent on the trigger question"
  it "should provide a list of dependent questions on the same page as the trigger question"
  it "should group dependents by expression"
end

describe Condition, "on a page" do
  it "should be invalid if trigger question is on this page"
  it "should be invalid if trigger question comes after this page"
end

describe Condition, "on a question" do
  it "should be invalid if trigger is a circular reference"
  it "should be invalid if trigger question comes after this question"
end
