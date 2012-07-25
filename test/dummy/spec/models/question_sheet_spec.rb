require 'spec_helper'

describe Qe::QuestionSheet do 

	before(:each) do
		# @question_sheet = Qe::QuestionSheet.new_with_page
		@question_sheet = FactoryGirl.create(:qs_with_page)
		@question_sheet.save!
		@page = @question_sheet.pages.first
		@page.save!
	end

	it "ELEMENTS" do	
		@page.elements.create!(:kind => 'Qe::TextField', :style => 'text_field', :label => 'elements label')
		@question_sheet.elements.count.should == 2

		# add page, element count should not change
		@question_sheet.pages.create!(:label => 'page 2', :number => 2)
		@question_sheet.elements.count.should == 2

		# add element to page 2
		@p2 = @question_sheet.pages.second
		@p2.elements.create!(:kind => 'Qe::TextField', :style => 'text_field', :label => 'elements label')
		@question_sheet.elements.count.should == 3
	end

	describe "SELF.NEW_WITH_PAGE" do
	  it "question sheet" do
			@question_sheet.pages.count.should == 1
		end
	end

	describe "DUPLICATE" do
		describe "page" do
			describe "single" do
				it "page count" do
					cloned = @question_sheet.duplicate
					cloned.save
					cloned.pages.count.should == 1
				end
				it "element count" do
					# add a question
					question = @page.elements.create!(:kind => 'Qe::TextField', :style => 'qe/text_field', :label => 'essay question')

					# clone and count elements
					clone = @question_sheet.duplicate
					clone.save!
					clone.elements.count.should == 2
				end
			end
			describe "multi" do
				it "page count" do
					# add another page
					@question_sheet.pages.create!(:label => "Page 2", :number => 2)
					@question_sheet.pages.count.should == 2

					# clone and count pages
					clone = @question_sheet.duplicate
					clone.save!
					clone.pages.count.should == 2
				end
				it "elements count" do
					# create 2 elements
					q1 = @page.elements.create!(:kind => 'Qe::TextField',   :style => 'qe/text_field',   :label => 'essay questions')
					q2 = @page.elements.create!(:kind => 'Qe::ChoiceField', :style => 'qe/choice_field', :label => 'choice quesiton')

					# clone and count
					clone = @question_sheet.duplicate
					clone.save!
					clone.elements.count.should == 3
				end
			end
		end
	end # end of DUPLICATE method
end
