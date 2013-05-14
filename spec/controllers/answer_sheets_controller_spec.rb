require 'spec_helper'

describe Qe::AnswerSheetsController do
  
  before(:each) do
    @question_sheet = FactoryGirl.create(:qs_with_page)
    @page = @question_sheet.pages.first

    # create answer_sheet_question_sheets object
    @answer_sheet = @question_sheet.answer_sheets.create
    @answer_sheet.save!

    @text_field = @page.elements.first
    @text_field.kind.should == 'Qe::TextField'
  end
  
  xit 'GET index' do
    get :index, use_route: 'qe'
  end
  
  xit 'POST create' do
    post :create, use_route: 'qe',
      question_sheet_id: @question_sheet.id

    @created = Qe::AnswerSheet.all.count.should == 2
  end
  
  xit 'GET edit' do
    get :edit, use_route: 'qe',
      id: @answer_sheet.id,
      a: 'test anchor'
  end
  
  xit 'GET show' do
    get :show,
      use_route: 'qe',
      question_sheet_id: @question_sheet.id,
      id: @answer_sheet.id

  end
  
  xit 'POST submit' do
    post :submit,
      use_route: 'qe',
      id: @answer_sheet.id
  end

end