# == Schema Information
#
# Table name: qe_answer_sheets
#
#  id                :integer          not null, primary key
#  question_sheet_id :integer          not null
#  completed_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Qe
  class AnswerSheet < ActiveRecord::Base
    belongs_to :question_sheet
    has_many :reference_sheets, 
      foreign_key: 'applicant_answer_sheet_id'
  end
end
