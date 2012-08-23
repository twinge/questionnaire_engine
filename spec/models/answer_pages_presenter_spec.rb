require 'spec_helper'

describe Qe::AnswerPagesPresenter do
	before(:each) do
		# create question_sheet with 1 page with 1 element
		@qs = FactoryGirl.create(:qs_with_page)
		@qs.save!

		# create answer_sheet_question_sheets object
		@as = @qs.answer_sheets.create!
		@as.save!

		# quesiton
		@question = @qs.pages.first.questions.first

		# need a controller class
	end

	it 'place holder' do
		@as.should_not == nil
	end
end
