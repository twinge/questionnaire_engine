module Qe
  class BaseController < ::ApplicationController
    unloadable
    layout 'qe/application'
    helper 'qe/answer_pages'
  end
end
