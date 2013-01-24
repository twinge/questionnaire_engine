# == Schema Information
#
# Table name: qe_answers
#
#  id              :integer          not null, primary key
#  answer_sheet_id :integer          not null
#  question_id     :integer          not null
#  value           :text
#  short_value     :string(255)
#  size            :integer
#  content_type    :string(255)
#  filename        :string(255)
#  height          :integer
#  width           :integer
#  parent_id       :integer
#  thumbnail       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Qe
  class Answer < ActiveRecord::Base
    belongs_to :answer_sheet
    belongs_to :question
  end
end
