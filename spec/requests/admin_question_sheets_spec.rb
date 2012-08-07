require 'spec_helper'

describe "AdminQuestionSheets" do
	before(:each) do
		@qs = create(:qs_with_page)
	end

  describe "GET /admin_question_sheets" do
    it "success" do
      get qe.admin_question_sheets_path
      response.status.should == 200
    end

    it "show admin_question_sheet" do
    	get qe.new_admin_email_template_path
    	response.status.should == 200
    end

    it "weston" do
    	get qe.admin_email_templates_path
    end
  end
end
