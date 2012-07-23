require 'spec_helper'

describe Qe::QuestionSheet do 

	before(:each) do
		@question_sheet = Qe::QuestionSheet.new_with_page
		@question_sheet.save
		@page = @question_sheet.pages.first
		@page.save
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
					question = @page.elements.build(:kind => 'Qe::TextField', :style => 'qe/text_field')
					question.label = 'essay quesiton'
					question.save!

					Qe::PageElement.create(:element => question, :page => @page)

					clone = @question_sheet.duplicate
					clone.save!
					clone.elements.count.should == 1
				end
			end
			describe "multi" do
				it "page count" do
					@question_sheet.pages.build(:label => "Page 2", :number => 2)
					@question_sheet.save!
					@question_sheet.pages.count.should == 2

					clone = @question_sheet.duplicate
					clone.save!
					clone.pages.count.should == 2
				end
				it "elements count" do
					q1 = @page.elements.build(:kind => 'Qe::TextField', :style => 'qe/text_field')
					q1.label = 'essay quesiton'
					q1.save!

					q2 = @page.elements.build(:kind => 'Qe::ChoiceField', :style => 'qe/choice_field')
					q2.label = 'choice quesiton'
					q1.save!

					pe1 = Qe::PageElement.create(:element => q1, :page => @page)
					pe2 = Qe::PageElement.create(:element => q2, :page => @page)

					pe1.save!
					pe2.save!

					clone = @question_sheet.duplicate
					clone.save!
					clone.elements.count.should == 2
				end
			end
		end
	end # end of DUPLICATE method



end
