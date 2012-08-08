require 'spec_helper'

describe "ElementsController requests" do
  
  before(:each) do
    visit qe.admin_question_sheets_path
    click_link 'New Questionnaire'
  end

  it 'add element' do
    click_link 'Elements'
    
    @question_sheet = Qe::QuestionSheet.all.first
    @question_sheet.should_not == nil
  end

  
end
