require 'spec_helper'

describe Qe::Admin::QuestionSheetsController do
  
  describe 'simple non-AJAX CRUD operations' do
    before(:each) do
      visit qe.admin_question_sheets_path
      click_link 'New Questionnaire'
    end
    
    it 'confirm new sheet' do    
      visit qe.admin_question_sheets_path
      within("#active") do
        page.should have_content 'Untitled form 1'
      end
    end
    it 'delete' do
      visit qe.admin_question_sheets_path
      click_link 'Destroy'
      page.should_not have_content 'Untitled form 1'
    end
    it 'archive' do
      visit qe.admin_question_sheets_path
      click_link 'Archive'
      within("#inactive") do
        page.should have_content 'Untitled form 1'
      end
    end
  end

end
