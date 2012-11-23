require 'spec_helper'

describe Qe::Admin::EmailTemplatesController do
  
  describe "GET /admin_email_templates_path" do
    xit "success" do
     	get qe.admin_email_templates_path
      response.status.should be(200)
    end
  end

end
