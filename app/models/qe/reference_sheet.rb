# == Schema Information
#
# Table name: qe_reference_sheets
#
#  id                        :integer          not null, primary key
#  question_id               :integer
#  applicant_answer_sheet_id :integer
#  email_sent_at             :datetime
#  relationship              :string(255)
#  title                     :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  phone                     :string(255)
#  email                     :string(255)
#  status                    :string(255)
#  submitted_at              :datetime
#  access_key                :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

module Qe
  class ReferenceSheet < ActiveRecord::Base
    
    # belongs_to :question, :class_name => Qe::Element, :foreign_key => 'question_id'
    # belongs_to :question, :class_name => Qe::Element, :foreign_key => 'question_id'
    belongs_to :applicant_answer_sheet, 
      :class_name => Qe::AnswerSheet, 
      :foreign_key => 'applicant_answer_sheet_id'

  end
end
