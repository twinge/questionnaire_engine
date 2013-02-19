module Qe
  class EmailTemplate < ActiveRecord::Base
    attr_accessible :name, :content, :enabled, :subject
  end
end  
