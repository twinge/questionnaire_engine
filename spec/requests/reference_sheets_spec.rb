require 'spec_helper'

describe "ReferenceSheetsPaths" do
  describe "GET /reference_sheets_path" do
    xit "success" do
      get :index
      response.status.should be(200)
    end
  end
end
