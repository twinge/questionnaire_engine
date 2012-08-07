require 'spec_helper'
 
describe "AnswerSheets" do
	before(:each) do
		include Rails.application.routes.url_helpers
		
		# create question_sheet with 1 page with 1 element
		@qs = FactoryGirl.create(:qs_with_page) and @qs.save!

		# create answer_sheet_question_sheets object
		@as = @qs.answer_sheets.create
		@as.answer_sheet_question_sheets.create!(:question_sheet => @qs)
		@as.save!

		# quesiton
		@question = @qs.pages.first.questions.first
	end

  describe "GET qe/answer_sheets" do
    it "success" do
      get qe.answer_sheets_path
      response.status.should == 200
    end
  end

  describe "SHOW qe/answer_sheet" do
  	it "success" do
  		get qe.answer_sheet_path(@as.id)
  		response.status.should == 200
  	end
  end

  describe "POST qe/answer_sheets" do
    it "success" do
      post qe.answer_sheets_path(:question_sheet_id => @qs.id)
      response.status.should == 302 # redirect to edit the new answer_sheet
    end
  end

  describe "EDIT qe/answer_sheet" do
  	it "success" do
  		page = @qs.pages.first
  		get qe.edit_answer_sheet_page_path(@as.id, page)
  		response.status.should == 200
  	end
  end
end
