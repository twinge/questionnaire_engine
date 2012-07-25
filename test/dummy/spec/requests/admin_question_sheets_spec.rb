require 'spec_helper'

describe "AdminQuestionSheets" do
  describe "GET /admin_question_sheets" do
    it "success" do
      get qe.admin_question_sheets_path
      response.status.should be(200)
    end
  end
end
