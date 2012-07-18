# should be required from lib/qe.rb
# require 'qe/model_extensions'

module Qe
  class Page < ActiveRecord::Base
    include Qe::Concerns::Models::Page
  end
end
