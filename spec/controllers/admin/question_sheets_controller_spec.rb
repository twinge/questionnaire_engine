require 'spec_helper'

describe Qe::Admin::QuestionSheetsController do 

  before(:each) do 
    @qs = FactoryGirl.create(:question_sheet)  
  end

  describe 'GET index' do 
    it 'with no question sheets' do 
      get :index, use_route: 'qe'
      response.status.should == 200
    end
  end
  
  describe 'GET show' do 
    it 'html' do 
      get :show, use_route:'qe', id: @qs.id
      response.should be_success
    end
  end

  describe 'GET new' do 
    it 'GET new' do 
      get :new, use_route: 'qe'
      response.should be_success
    end
  end

  describe 'GET edit' do 
    it 'should fetch appropriate record' do 
      xhr :get, :edit, use_route: :qe, id: @qs.id
      response.should be_success
    end
  end

  describe 'POST create' do 
    it 'should create question_sheet' do
      new_qs = { label: 'new_qs label'}
      post :create, use_route: :qe, question_sheet: new_qs
      Qe::QuestionSheet.count.should == 2
    end
  end

  describe 'PUT update' do 
    it 'should update object' do 
      new_label = 'update'
      updated_qs = { label: new_label}

      put :update, use_route: :qe, id: @qs.id, question_sheet: updated_qs
      Qe::QuestionSheet.find(@qs.id).label.should == new_label
    end
  end

  describe 'DELETE destroy' do 
    it 'should delete question_sheet' do 
      delete :destroy, use_route: :qe, id: @qs.id
      Qe::QuestionSheet.count.should == 0 
    end
  end
end
