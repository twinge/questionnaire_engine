require 'spec_helper'

describe Qe::AnswerPagesPresenter do
	before(:each) do
		# create question_sheet with 1 page with 1 element
		@qs = FactoryGirl.create(:qs_with_page)
		@qs.save!

		# create answer_sheet_question_sheets object
		@as = @qs.answer_sheets.create
		@as.answer_sheet_question_sheets.create!(:question_sheet => @qs)
		@as.save!

		# quesiton
		@question = @qs.pages.first.questions.first

		# need a controller class
	end

	xit "INITIALIZE" do
	end

	xit "QUESTIONS_FOR_PAGE" do
	end

	xit "ALL_QUESTIONS_FOR_PAGE" do
	end

	xit "SHEET_TITLE" do
	end

	xit "ACTIVE_PAGE" do
	end

	xit "NEXT_PAGE" do
	end

	xit "REFERENCE?" do
	end

	xit "INITIALZE_PAGES?" do
	end

	xit "STARTED?" do
	end

	xit "NEW_PAGE_LINK" do
	end

	xit "REFERENCE?" do
	end
end
