require 'spec_helper'

describe Qe::Admin::QuestionPagesController do

	before(:each) do
		@question_sheet = create(:qs_with_page)
		@page = @question_sheet.pages.first

		@text_field = @page.elements.first
		@text_field.kind.should == 'Qe::TextField'
	end
	it 'object check' do
		@page.elements.count.should == 1
	end
	
	it 'GET show' do
		xhr :get, :show,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			id: @page.id
	end
	it 'GET edit' do
		xhr :get, :edit,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			id: @page.id
	end
	it 'POST create' do
		xhr :post, :create,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id

		@question_sheet.pages.count.should == 2
	end
	it 'PUT update' do
		new_label = "page's new label"
		@page.label = new_label
		
		xhr :put, :update,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			id: @page.id,
			page: @page.attributes

		@updated_page = Qe::Page.find(@page.id)
		@updated_page.label.should == new_label
	end
	it 'DELETE destroy' do
		xhr :post, :create,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id

		@question_sheet.pages.count.should == 2

		xhr :delete, :destroy,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			id: @question_sheet.pages.second.id

		@question_sheet.pages.count.should == 1
	end
	it 'GET show_panel' do
		xhr :get, :show_panel,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			id: @page.id
	end
	it 'POST reorder' do
		xhr :post, :create,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id

		@question_sheet.pages.count.should == 2
		
		@first = @page
		@second = @question_sheet.pages.second
		order = ["#{@second.id}", "#{@first.id}"]

		xhr :post, :reorder,
			use_route: 'qe',
			question_sheet_id: @question_sheet.id,
			"list-pages" => order

		@uncached_qs = Qe::QuestionSheet.find(@question_sheet.id)
		@uncached_qs.pages.first.id.should == @second.id
		@uncached_qs.pages.second.id.should == @first.id
	end
end