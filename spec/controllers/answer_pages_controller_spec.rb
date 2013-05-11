require 'spec_helper'

describe Qe::AnswerPagesController do
  
  before(:each) do
    @question_sheet = FactoryGirl.create(:qs_with_page)
    @page = @question_sheet.pages.first

    # create answer_sheet_question_sheets object
    @answer_sheet = @question_sheet.answer_sheets.create!

    @text_field = @page.elements.first
    @text_field.kind.should == 'Qe::TextField'
  end
  
  it 'GET edit' do
    get :edit, use_route: 'qe',
      answer_sheet_id: @answer_sheet.id,
      a: 'test anchor',
      id: @page.id
  end

  # TODO test controller for references
  it 'PUT update' do
    questions = Qe::Page.find(@page.id).questions
    question2 = @page.questions.build(:kind => 'Qe::TextField', :style => 'qe/text_field')
    question2.save!

    answer = @answer_sheet.answers.create!(question_id: @text_field.id, value: 'value 1')
    answer2 = @answer_sheet.answers.create(question_id: question2.id, value: 'value 2')

    @answer_sheet.answers.first.value = 'new 1'
    @answer_sheet.answers.second.value = 'new 2'
    
    # creates hash of answers attributes, which are posted
    answers_hash = @answer_sheet.answers.map{|a| a.attributes }.inject{|result, attributes| result.merge(attributes)}

    put :update, 
      use_route: 'qe',
      answer_sheet_id: @answer_sheet.id,
      a: 'anchor',
      id: @page.id,
      answers: answers_hash
  end
  
end