require 'spec_helper'

describe Qe::Page do 

	it { should belong_to :question_sheet } 
	it { should have_many :page_elements }
	it { should have_many :elements }
	it { should have_many :question_grid_with_totals }
	it { should have_many :questions }
	it { should have_many :question_grids }
	
	before(:each) do
		@question_sheet = FactoryGirl.create(:qs_with_page)
		@page = @question_sheet.pages.first
	end
	
	xit '#completed?'
	xit '#started?'
	
	it 'has_questions?' do
		@question_sheet.elements.count.should_not == 0
		@page.has_questions?.should == true
	end
end