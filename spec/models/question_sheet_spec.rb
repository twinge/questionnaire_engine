require File.dirname(__FILE__) + '/../spec_helper'

module QuestionSheetSpecHelper
  
end


describe QuestionSheet, 'validation' do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.new
  end

  it "should be invalid without a label" do
    @sheet.attributes = valid_question_sheet.except(:label)
    @sheet.should_not be_valid
    @sheet.should have(1).error_on(:label)
    #@sheet.errors.on(:label).should == "can't be blank"
    @sheet.errors.size.should == 1  # no other errors
  end
  
  it "should be invalid when label is over 60 characters long" do
    @sheet.attributes = valid_question_sheet.with(:label => "a" * 61)
    @sheet.should_not be_valid
    @sheet.should have(1).error_on(:label)
    @sheet.errors.size.should == 1  # no other errors
  end
  
  it "should be invalid if the label is already in use" do
    QuestionSheet.create(valid_question_sheet)
    
    @sheet.attributes = valid_question_sheet
    @sheet.should_not be_valid
    
    @sheet.label = 'another form'
    @sheet.should be_valid
  end
  
  it "should be valid with a full set of valid attributes" do
    @sheet.attributes = valid_question_sheet
    @sheet.should be_valid
  end
  
end


# functional
describe QuestionSheet, "with pages" do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.create(valid_question_sheet)
  end
  
  it "should have pages" do
    @sheet.should respond_to(:pages)
    @sheet.pages.should have(0).records
  end
 
end

describe QuestionSheet, ".untitled_labels" do
  include QuestionnaireFixture
  
  it "should only return labels that begin with 'Untitled form'" do
    QuestionSheet.create(valid_question_sheet.with(:label => "The sheet I named"))
    QuestionSheet.create(valid_question_sheet.with(:label => "Untitled form 1"))
    
    labels = QuestionSheet.untitled_labels
    labels.should have(1).members
    labels.should include("Untitled form 1")
    labels.should_not include("The sheet I named")
  end
  
end

describe QuestionSheet, ".next_label" do
  include QuestionnaireFixture
  
  it "should return the successor to the highest label" do
    # mock existing forms
    QuestionSheet.should_receive(:untitled_labels).and_return(["Untitled form 13", "Untitled form 40"])
    
    QuestionSheet.next_label.should == "Untitled form 41"
  end
  
end

