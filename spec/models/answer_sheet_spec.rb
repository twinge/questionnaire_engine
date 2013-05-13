require 'spec_helper'

describe Qe::AnswerSheet do 

	it { should have_many :answer_sheet_question_sheets }
	it { should have_many :question_sheets }
	it { should have_many :answers }
	it { should have_many :reference_sheets }
	
	# before(:each) do
	# 	# create question_sheet with 1 page with 1 element
	# 	@qs = FactoryGirl.create(:qs_with_page) and @qs.save!

	# 	# create answer_sheet_question_sheets object
	# 	@as = @qs.answer_sheets.create!

	# 	# quesiton
	# 	@question = @qs.pages.first.questions.first
	# end

	# it "COPY_TO" do
	# 	# tested in spec/models/question_sheet_spec.rb
	# end
	
 	xit '#answers_by_question' do
 		answer = Qe::Answer.new(:answer_sheet => @as, :question =>  @question, :value => 'value')
 		answer.save!
 		@as.answers_by_question.count.should == 1
	end
	
	xit '#question_sheet' do
		@as.question_sheet.should == @as.question_sheets.first
	end

	xit '#complete?' do
		@as.completed_at = nil
		@as.complete?.should == false
	end
	
	xit '#count_questions' do 
		# 1 element => 1 question
		@as.count_questions.should == 1
	end
	
	xit '#count_answers' do
		@as.count_answers.should == 0
		
		Qe::Answer.create!(:answer_sheet => @as, :question =>  @question, :value => 'value')
		@as.answers.count.should == 1
	end

end