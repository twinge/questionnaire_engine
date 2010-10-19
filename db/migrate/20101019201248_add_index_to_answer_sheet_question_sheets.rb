class AddIndexToAnswerSheetQuestionSheets < ActiveRecord::Migration
  def self.up
    add_index AnswerSheetQuestionSheet.table_name, :answer_sheet_id
    add_index AnswerSheetQuestionSheet.table_name, :question_sheet_id
  end

  def self.down
    remove_index AnswerSheetQuestionSheet.table_name, :question_sheet_id
    remove_index AnswerSheetQuestionSheet.table_name, :answer_sheet_id
  end
end