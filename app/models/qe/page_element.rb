module Qe
  class PageElement < ActiveRecord::Base
    belongs_to :page
    belongs_to :element
  end
end
