require 'spec_helper'

describe "AnswerSheets" do
  describe "GET qe/answer_sheets" do
    it "success" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get qe.answer_sheets_path
      response.status.should be(200)
    end
  end
end
