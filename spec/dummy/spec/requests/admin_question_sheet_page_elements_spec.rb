require 'spec_helper'

describe "AdminQuestionSheetPageElementsPaths" do
  describe "GET /admin/question_sheet/elements" do

  	before(:each) do
  		# @user = create(:user_with_account)
    	# sign_in(:user, @user)
   	 	# @contact = create(:contact, account_list: @user.account_lists.first)

      @question_sheet = create(:question_sheet)
      @page = @question_sheet.pages.first
    end
    
    xit "success" do
    	# need to provide
    	# question_sheet_id 
    	# pages_id
      # get qe.admin_question_sheet_page_elements_path
      # response.status.should be(200)
    end
  end
end
