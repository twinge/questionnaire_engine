require 'spec_helper'

describe Qe::Admin::QuestionSheetsController do 

  # before(:each) do
  #   request.env["HTTP_REFERER"] = "something"

  #   @question_sheet = FactoryGirl.create(:qs_with_page)
  #   @page = @question_sheet.pages.first

  #   # create answer_sheet_question_sheets object
  #   # @answer_sheet = @question_sheet.answer_sheets.create!
  #   @answer_sheet = FactoryGirl.create(:answer_sheet, question_sheet: @question_sheet)

  #   @text_field = @page.elements.first
  #   @text_field.kind.should == 'Qe::TextField'
  # end

  xit 'GET index' do
    get :index,
      use_route: 'qe'
  end
  xit 'POST archive' do
    post :archive,
      use_route: 'qe',
      id: @question_sheet.id

  end
  xit 'POST unarchive' do
    post :unarchive,
      use_route: 'qe',
      id: @question_sheet.id
  end
  xit 'POST update' do
    post :duplicate,
      use_route: 'qe',
      id: @question_sheet.id
  end
  xit 'GET show' do
    get :show,
      use_route: 'qe',
      id: @question_sheet.id
  end
  xit 'POST create' do
    post :create,
      use_route: 'qe'
  end 
  xit 'GET edit' do
    xhr :get, :edit,
      use_route: 'qe',
      id: @question_sheet.id
  end
  # it 'PUT update' do
  #   new_label = 'test new label'
  #   @question_sheet.label = new_label
    
  #   put :udpate,
  #     use_route: 'qe',
  #     id: @question_sheet.id,
  #     question_sheet: @question_sheet.attributes

  #   @updated_question_sheet = Qe::QuestionSheet.find(@question_sheet.id)
  #   @updated_question_sheet.label.should == new_label
  # end
  xit 'DELETE destroy' do
    delete :destroy,
      use_route: 'qe',
      id: @question_sheet.id

    # make sure it was deleted
    Qe::QuestionSheet.all.count.should == 0
  end
end