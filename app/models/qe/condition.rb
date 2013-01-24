# == Schema Information
#
# Table name: qe_conditions
#
#  id                :integer          not null, primary key
#  question_sheet_id :integer          not null
#  trigger_id        :integer          not null
#  expression        :string(255)      not null
#  toggle_page_id    :integer          not null
#  toggle_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Qe
  class Condition < ActiveRecord::Base
    belongs_to :question_sheet
  end
end
