require 'spec_helper'

describe Qe::Admin::QuestionPagesController do 

  before(:each) do 
    @qs = Qe::QuestionSheet.create_with_page
    @page = @qs.pages.first
  end


  describe 'GET show' do 
    it 'js' do 
      xhr :get, :show, 
        format: :js,
        use_route: :qe, 
        id: @page.id, 
        question_sheet_id: @qs.id
      response.should be_success
    end
    
    it 'json' do 
      xhr :get, :show, 
        format: :json,
        use_route: :qe, 
        id: @page.id, 
        question_sheet_id: @qs.id
      response.should be_success
    end
  end


  describe 'GET edit' do 
    it 'js' do 
      xhr :get, :show, 
        format: :js,
        use_route: :qe, 
        id: @page.id, 
        question_sheet_id: @qs.id
      response.should be_success
    end
    
    it 'json' do 
      xhr :get, :show, 
        format: :json,
        use_route: :qe, 
        id: @page.id, 
        question_sheet_id: @qs.id
    end
  end


  describe 'POST create' do 
    it 'js' do 
      xhr :get, :create,
        use_route: :qe,
        question_sheet_id: @qs.id
      response.should be_success
    end

    it 'json' do 
      xhr :post, :create,
        format: :json, 
        use_route: :qe, 
        question_sheet_id: @qs.id
      response.body.should == 'success'
    end
  end


  describe 'PUT update' do 
    it 'js' do 
      page_params = {label: 'new label'}

      xhr :put, :update,
        use_route: :qe,
        id: @page.id, 
        question_sheet_id: @qs.id,
        page: page_params
      response.should be_success
    end

    it 'json' do 
      page_params = {label: 'new label'}

      xhr :put, :update,
        use_route: :qe,
        format: :json,
        id: @page.id, 
        question_sheet_id: @qs.id,
        page: page_params

      response.body.should == 'success'
    end
  end

  
end
