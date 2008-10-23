require File.dirname(__FILE__) + '/../spec_helper'

describe TextField do
  before(:each) do
    @text_field = TextField.new
  end

  it "should be a question" do
    @text_field.should be_a_kind_of(Question)
    @text_field.should be_a_question
  end
end