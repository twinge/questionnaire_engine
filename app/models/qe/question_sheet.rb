# == Schema Information
#
# Table name: qe_question_sheets
#
#  id         :integer          not null, primary key
#  label      :string(100)      not null
#  archived   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Qe
  class QuestionSheet < ActiveRecord::Base
    has_many :pages
    has_many :conditions
    has_many :questions,
      foreign_key: 'related_question_sheet_id'


    attr_accessible :label

    def self.create_with_page
      question_sheet = self.create(:label => 'My New Question Sheet')
      question_sheet.pages.build(:label => 'Page 1', :number => 1)
      question_sheet.save
      question_sheet
    end

  end
end

