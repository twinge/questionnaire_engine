require File.dirname(__FILE__) + '/../spec_helper'


describe Page, "creation" do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.create(valid_question_sheet)
  end
  
  
  it "should be assigned a default label" do
    page = Page.new(valid_page(@sheet).except(:label))
    page.should be_valid
    page.label.should == "Page 1"
  end
  
  it "should return the successor to the highest label" do
    # mock existing labels
    Page.should_receive(:untitled_labels).with(@sheet).and_return(["Page 1", "Page 2"])
    
    page = @sheet.pages.create(valid_page(@sheet).except(:label))
    page.save.should be_true
    page.label.should == "Page 3"
  end
  
end


describe Page, 'validation' do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.create(valid_question_sheet)
    @page = Page.new
  end

    
  it "should be valid" do
    @page.attributes = valid_page(@sheet)
    @page.should be_valid
  end
end


describe Page, "with conditions" do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.create(valid_question_sheet)
    @page = Page.create(valid_page(@sheet))
  end
  
  it "should be active if no conditions" do
    @page.should be_active
  end
  
  it "should be active with a condition that evaluates to true"
  
  it "should be inactive with a condition that evaluates to false"
  
end
