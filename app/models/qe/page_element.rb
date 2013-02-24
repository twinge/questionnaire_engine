# == Schema Information
#
# Table name: qe_page_elements
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  element_id :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Qe
  class PageElement < ActiveRecord::Base
    belongs_to :page
    belongs_to :element

    attr_accessible :page_id, :element_id, :position

    # acts_as_list :scope => :page
  end
end
