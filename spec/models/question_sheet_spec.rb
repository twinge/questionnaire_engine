require 'spec_helper'

describe Qe::QuestionSheet do 

	it { should have_many :answer_sheet_question_sheets }
	it { should have_many :answer_sheets }
	it { should have_many :pages }
	it { should have_many :elements }
	it { should validate_presence_of :label }
	it { should validate_uniqueness_of :label }

	before(:each) do
		@question_sheet = FactoryGirl.create(:qs_with_page)
		@page = @question_sheet.pages.first
		@page.save!
	end

	describe '.new_with_page' do
	  it 'question sheet' do
			@question_sheet.pages.count.should == 1
		end
	end

	describe '#duplicate' do
		describe 'page' do
			describe 'single' do
				xit 'page count' do
					cloned = @question_sheet.duplicate
					cloned.save
					cloned.pages.count.should == 1
				end
				xit 'element count' do
					# add a question
					question = @page.elements.create!(:kind => 'Qe::TextField', :style => 'qe/text_field', :label => 'essay question')

					# clone and count elements
					clone = @question_sheet.duplicate
					clone.save!
					clone.elements.count.should == 2
				end
			end
			describe 'multi' do
				xit 'page count' do
					# add another page
					@question_sheet.pages.create!(:label => "Page 2", :number => 2)
					@question_sheet.pages.count.should == 2

					# clone and count pages
					clone = @question_sheet.duplicate
					clone.save!
					clone.pages.count.should == 2
				end
				xit 'elements count' do
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
	end
end
