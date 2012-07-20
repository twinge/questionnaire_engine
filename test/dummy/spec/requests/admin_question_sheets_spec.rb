require 'spec_helper'

describe "AdminQuestionSheets" do
  describe "GET /admin_question_sheets" do
    it "success" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get qe.admin_question_sheets_path
      response.status.should be(200)
    end
  end
end


