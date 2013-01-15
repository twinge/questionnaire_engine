require 'spec_helper'

describe Qe::Admin::QuestionSheetsController do 

  before do 
  end

  it 'GET index' do 
    get :index, use_route: 'qe'
    response.status.should == 200
  end
    
  it 'html' do 
    @question_sheet = FactoryGirl.create(:question_sheet)  
    get :show, use_route:'qe', id: @question_sheet.id
    response.should be_success
  end

  it 'GET new' do 
    get :new, use_route: 'qe'
    response.should be_success
  end

  def json_to_ruby(json, opts={})
    options = {symbolize_names:true}
    options.merge(opts)
    JSON.parse(json, options)
  end
end
