module Qe
  module Admin
    class AdminControllers < ::ApplicationController

      unloadable
      layout 'qe/qe.admin'

      # before_filter :authenticate_user!

    end
  end
end
