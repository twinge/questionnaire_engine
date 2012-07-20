require 'spec_helper'

describe Qe::QuestionSheet do 
	
	describe "DUPLICATE" do
		it "question sheet" do
			q = Qe::QuestionSheet.new_with_page
			q.save
			q.pages.count.should == 1
		end
		
		describe "page" do
			it "single" do
				q = Qe::QuestionSheet.new_with_page
				q.save
				cloned = q.duplicate
				cloned.save
				cloned.pages.count.should == 1
			end

			it "multi" do
				q = Qe::QuestionSheet.new_with_page
				q.save
				q.pages.build(:label => "Page 2", :number => 2)
				q.save
				q.pages.count.should == 2

				cloned = q.duplicate
				cloned.save
				cloned.pages.count.should == 2
			end
		end
	end # end of DUPLICATE method

	describe "answer sheets" do
	end

end
