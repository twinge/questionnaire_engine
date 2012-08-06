require 'spec_helper'
require 'qe/engine'

describe "Page Link" do
	before(:each) do
		@qs = Qe::QuestionSheet.new_with_page
		@qs.save!

		@as = @qs.answer_sheets.create!
		@as.answer_sheet_question_sheets.create!(:question_sheet => @qs)		
	end
	xit "INTIALIZE" do
		label = "this is a test label"
		dom_id = "this is a test dom_id"
		page = @qs.pages.first
		
		path_to_edit_answer_sheet = qe.edit_answer_sheet_page_path(@as, page)
		get path_to_edit_answer_sheet
		response.status.should == 200 

		pl = Qe::PageLink.new(label, path_to_edit_answer_sheet, dom_id, page)

		# pl.label.should == label
		# pl.load_path.should == 

		true.should == true
	end 
end


 # 	  def initialize(label, load_path, dom_id, page)
 #      @label = label
 #      @load_path = load_path
 #      @dom_id = dom_id
 #   		@page = page
 #  	end