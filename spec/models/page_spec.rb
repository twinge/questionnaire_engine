require 'spec_helper'

describe Qe::Page do 
	before(:each) do
		@question_sheet = FactoryGirl.create(:qs_with_page)
		@page = @question_sheet.pages.first
	end
	xit "COMPLETED?" do
	end
	
	xit "STARTED?" do
	end
	
	it "HAS_QUESTIONS?" do
		@question_sheet.elements.count.should_not == 0
		@page.has_questions?.should == true
	end
end