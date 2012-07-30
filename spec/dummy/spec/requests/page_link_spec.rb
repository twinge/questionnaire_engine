require 'spec_helper'
require 'qe/concerns/models/page_link'

describe "Page Link" do
	before(:each) do
		@qs = Qe::QuestionSheet.new_with_page
		@qs.save!

		@as = @qs.answer_sheets.create!
		@as.answer_sheet_question_sheets.create!(:question_sheet => @qs)		
	end
	it "INTIALIZE" do
		answer_sheet = @as
		page = @qs.pages.count.should_not == nil
		# pl = Qe::PageLink.new_page_link(answer_sheet, page)
		# pl.should_not == nil

	end 
end
