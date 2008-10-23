require File.dirname(__FILE__) + '/../spec_helper'

describe Element, "that is empty" do
  before(:each) do
    @element = Element.new
  end

  it "should not be valid" do
    @element.should_not be_valid
    @element.should have(2).error_on(:kind)
  end
  
end

