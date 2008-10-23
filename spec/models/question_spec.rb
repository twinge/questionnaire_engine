require File.dirname(__FILE__) + '/../spec_helper'

describe Question, "when new" do
  before(:each) do
    @question = Question.new
  end

  it "should be a kind of Element" do
    @question.should be_a_kind_of(Element)
  end
  
end

describe Question, "validation" do
  include QuestionnaireFixture
  
  before(:each) do
    @sheet = QuestionSheet.new(valid_question_sheet)
    @page = Page.new(valid_page(@sheet)) 
    @question = TextField.new(valid_question(@sheet, @page))
  end

  it "should be valid with a full set of valid attributes" do
    @question.kind.should == 'TextField'
    @question.should be_valid
    @question.save.should be_true
  end
end

describe Question, "with answers" do
  include QuestionnaireFixture
  
  before(:each) do
    # create a questionnaire
    @qs = QuestionSheet.create(valid_question_sheet)
    @page = Page.create(valid_page(@qs)) 
    @question = TextField.create(valid_question(@qs, @page).merge(:required => true))

    # answer sheet
    @as = @qs.answer_sheets.create()
  end
  
  it "should be valid with an answer" do
    # save answer
    response = 'Hello'
    @question.answers = [@as.answers.new(:question_id => @question.id, :value => response, :short_value => response)]
    
    @question.should have_response
    @question.should be_valid
  end
  
end