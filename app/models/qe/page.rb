# == Schema Information
#
# Table name: qe_pages
#
#  id                :integer          not null, primary key
#  question_sheet_id :integer          not null
#  label             :string(60)       not null
#  number            :integer
#  no_cache          :boolean          default(FALSE)
#  hidden            :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Qe
  class Page < ActiveRecord::Base
    has_many :page_elements
    has_many :elements, :through => :page_elements, :dependent => :destroy, :order => :position
    belongs_to :question_sheet
  end
end
