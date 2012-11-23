require 'spec_helper'

describe Qe::Admin::QuestionPagesController do

	before(:each) do
		visit qe.admin_question_sheets_path
		click_link 'New Questionnaire'
		visit qe.admin_question_sheets_path
	end

	xit 'confirm page 1' do
		click_link 'Untitled form 1'
		page.should have_content 'Page 1'
	end

	xit 'add page 2' do
		click_link 'Untitled form 1'
		click_link 'Add a page'

		@question_sheet = Qe::QuestionSheet.all.first
		@question_sheet.pages.count.should == 2
	end
	
end