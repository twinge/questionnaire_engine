# == Schema Information
#
# Table name: qe_page_elements
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  element_id :integer
#  position   :integer
#

module Qe
  class PageElement < ActiveRecord::Base
    belongs_to :page
    belongs_to :element
  end
end
