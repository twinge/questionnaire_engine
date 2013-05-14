require 'spec_helper'

describe Qe::ReferenceSheetsController do 
  
  # before(:each) do
  #   @question_sheet = FactoryGirl.create(:qs_with_page)
  #   @page = @question_sheet.pages.first

  #   # create answer_sheet_question_sheets object
  #   @answer_sheet = @question_sheet.answer_sheets.create!
    
  #   element = @page.elements.create!(
  #     kind: 'Qe::ReferenceQuestion', 
  #     style: 'qe/reference_question', 
  #     related_question_sheet_id: @question_sheet.id
  #   )

  #   @ref_question = Qe::ReferenceQuestion.find(element.id)
  #   @ref_sheet = @ref_question.response(@answer_sheet)

  #   ref = {
  #     first_name: 'f',
  #     last_name: 'l',
  #     phone: '123',
  #     email: 'a@a.com',
  #     relationship: 'test',
  #     access_key: @ref_sheet.generate_access_key
  #   }
  #   @ref_sheet.update_attributes(ref, :without_protection => true)
  # end

  xit 'GET edit' do
    get :edit, use_route: 'qe',
      id: @ref_sheet.id,
      a: @ref_sheet.generate_access_key
  end 
end