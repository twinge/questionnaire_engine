class AddIndexToAnswerSheetQuestionSheets < ActiveRecord::Migration
  def self.up
    add_index :qe_answer_sheet_question_sheets, :answer_sheet_id
    add_index :qe_answer_sheet_question_sheets, :question_sheet_id
  end

  def self.down
    remove_index :qe_answer_sheet_question_sheets, :question_sheet_id
    remove_index :qe_answer_sheet_question_sheets, :answer_sheet_id
  end
end