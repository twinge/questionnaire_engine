require 'spec_helper'

describe Qe::Admin::EmailTemplatesController do
  describe "GET /admin_email_templates_path" do
    it "success" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get qe.admin_email_templates_path
      response.status.should be(200)
    end
  end
end
