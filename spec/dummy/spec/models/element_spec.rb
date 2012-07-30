require 'spec_helper'

describe Qe::Element do 
	before(:each) do
		@element = create(:element)
		@element.save!
	end
	it "check label" do
		@element.label.should_not be_empty
	end
end
