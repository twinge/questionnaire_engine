require 'spec_helper'

describe "ReferenceSheetsPaths" do
  describe "GET /reference_sheets_path" do
    it "success" do
      get qe.reference_sheets_path
      response.status.should be(200)
    end
  end
end
