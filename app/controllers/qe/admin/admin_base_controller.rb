module Qe
  class Admin::AdminBaseController < ::ApplicationController  

    unloadable
    layout 'qe/qe.admin'
    before_filter :check_valid_user

  end
end
