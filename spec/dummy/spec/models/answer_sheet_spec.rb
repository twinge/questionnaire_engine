require 'spec_helper'

describe Qe::AnswerSheet do 
	before(:each) do
		# create question_sheet with 1 page with 1 element
		@qs = FactoryGirl.create(:qs_with_page) and @qs.save!

		# create answer_sheet_question_sheets object
		@as = @qs.answer_sheets.create
		@as.answer_sheet_question_sheets.create!(:question_sheet => @qs)
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
	xit "COMPLETELY_FILLED_OUT?" do
		# method needs to be implemented,
		# Element.has_response?
	end
	it "HAS_ANSWER_FOR?" do
		# have a question, but no answer
		@as.has_answer_for?(@question.id).should == false
		
		# create an answer for question
		answer = Qe::Answer.create!(:answer_sheet => @as, :question => @question)
		
		# question has answer
		@as.has_answer_for?(@question.id) == true
	end
	it "REFERENCE?" do
		# the extent of the method
		@as.reference?.should == false
	end
	it "COUNT_ANSWERS" do
		a1 = Qe::Answer.create!(:answer_sheet => @as, :question =>  @question, :value => "not nil")
		@as.count_answers.should == 1
	end
	it "COUNT_QUESTIONS" do
		# FactoryGirl :qs_with_page creates 1 question (element)
		@as.count_questions.should == 1
		
		# add a question to page 1
		page = @qs.pages.first
		q2 = page.elements.create!(:kind => 'Qe::ChoiceField', :style => 'qe/choice_field', :label => 'as_spec')
		q2.save!
		@qs.save!
		@as.save!

		# create question_sheet 2
		qs2 = Qe::QuestionSheet.new_with_page and qs2.save!
		asqs2 = @as.answer_sheet_question_sheets.create(:question_sheet => qs2)
		asqs2.save!
		page2 = asqs2.question_sheet.pages.first
		page2.elements.create!(:kind => 'Qe::DateField', :style => 'qe/date_field', :label => 'date field label')

		# count questions across multi question sheets w/ multi pages w/ muli question sheets
		@as.count_questions.should == 3
	end
	it "PERCENT_COMPLETE" do
		# with 1 question, 0 answers, EQUALS 0% 
		@as.percent_complete.should == 0

		# with 1 question, 1 answer, EQUALS 99
		answer = Qe::Answer.create!(:answer_sheet => @as, :question => @question, :value => 'not nil')
		@as.percent_complete.should == 99

		# add question 2
		page = @qs.pages.first
		page.elements.create!(:kind => 'Qe::ChoiceField', :style => 'qe/choice_field', :label => 'as_spec')
		q2 = @qs.pages.first.questions.second

		# with 2 questions, 1 answer, EQUALS 50
		@as.count_questions.should == 2
		@as.percent_complete.should == 50
		
		# add answer value, EQUALS 99
		a2 = Qe::Answer.create!(:answer_sheet => @as, :question => q2, :value => 'not nil')
		@as.percent_complete.should == 99
	end
	it "PAGES" do
		@as.pages.count.should == 1
	end
end