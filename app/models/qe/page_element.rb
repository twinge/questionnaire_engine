module Qe
	class PageElement < ActiveRecord::Base
    
    module M
      extend ActiveSupport::Concern

      included do
        # self.table_name = "#{self.table_name}"
        # acts_as_list :scope => :page
        belongs_to :page
        belongs_to :element

        attr_accessible :page, :element, :position
      end
    end

    include M
  end
end
