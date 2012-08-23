require 'spec_helper'

describe Qe::AnswerSheet do 
	before(:each) do
		# create question_sheet with 1 page with 1 element
		@qs = FactoryGirl.create(:qs_with_page) and @qs.save!

		# create answer_sheet_question_sheets object
		@as = @qs.answer_sheets.create!
		@as.save!

		# quesiton
		@question = @qs.pages.first.questions.first
	end

	# it "COPY_TO" do
	# 	# tested in spec/models/question_sheet_spec.rb
	# end
	
 	it "ANSWERS_BY_QUESTION" do
 		answer = Qe::Answer.new(:answer_sheet => @as, :question =>  @question)
 		answer.save!
 		@as.answers_by_question.count.should == 1
	end
	it "QUESTION_SHEET" do
		@as.question_sheet.should == @as.question_sheets.first
	end
	it "COMPLETE?" do
		@as.completed_at = nil
		@as.complete?.should == false
	end
end