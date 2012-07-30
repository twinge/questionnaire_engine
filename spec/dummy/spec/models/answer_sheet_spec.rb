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
	describe "QUESTION_SET_FOR_PAGE" do
		it "mutli pages" do
			# check returned class
			set = @as.questions_for_page
			set.class.should == Qe::QuestionSet

			# add page 2 with 2 elements/questions
			p2 = @qs.pages.create!(:number => 2, :label => "page 2")
			p2.elements.create!(:kind => "Qe::DateField", :label => 'questions_for_page df')
			p2.elements.create!(:kind => "Qe::TextField", :label => 'questions_for_page tf')

			# utlize method's argument selction of page id
			set = nil
			set = @as.questions_for_page(p2.id)
			set.class.should == Qe::QuestionSet
			set.elements.count.should == 2
		end
	end
	describe "ALL_QUESTION_SET_FOR_PAGE" do
		it "multi pages" do
			# verify set has 1 element
			set = @as.questions_for_page
			set.elements.count.should == 1

			# elements captured QUESTIONS_FOR_PAGE and 
			# ALL_QUESTIONS_FOR_PAGE should be the same
			non_nested = @as.questions_for_page.elements
			nested = @as.all_questions_for_page.elements
			non_nested.should == nested

			# add nested element, which is captured by ALL_QUESTIONS_FOR_PAGE, 
			# but not captured by ALL_QUESTIONS_FOR_PAGE
			page = @qs.pages.first
			grid = page.elements.create!(:kind => 'Qe::QuestionGrid', :label => 'grid label')
			elem = page.elements.create!(:kind => 'Qe::DateField', :label => 'grid date label', :question_grid_id => grid.id)

			# verify nest-ation is valid
			g = Qe::QuestionGrid.find(grid.id)
			g.elements.include?(elem).should == true

			non_nested = @as.questions_for_page.elements
			nested = @as.all_questions_for_page.elements

			nested.count.should == 1 + non_nested.count
		end
	end
	it "SHEET_TITLE" do
		title = @as.question_sheet.label
		@as.sheet_title.should == title
	end
	# need pagelink
	xit "ACTIVE_PAGE" do
	end
	# need pagelink
	xit "NEXT_PAGE" do
	end
	xit "REFERENCE?" do
	end
	it "INITIALZE_PAGES" do
		page = @as.question_sheet.pages.first
		@as.pages.include?(page).should == true
	end
	xit "STARTED?" do
		# Element.has_response? nees to be implemented before method testable
	end

end