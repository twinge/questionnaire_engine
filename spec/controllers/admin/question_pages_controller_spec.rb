require 'spec_helper'

describe Qe::Admin::QuestionSheetsController do 

  before(:all) do 
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
    end
    
    it 'json' do 
      xhr :get, :show, 
        format: :json,
        use_route: :qe, 
        id: @page.id, 
        question_sheet_id: @qs.id
    end

  end


end
