class CreateAnswerSheetQuestionSheets < ActiveRecord::Migration
  def self.up
    create_table AnswerSheetQuestionSheet.table_name do |t|
      t.integer :answer_sheet_id
      t.integer :question_sheet_id

      t.timestamps
    end
  end

  def self.down
    drop_table AnswerSheetQuestionSheet.table_name
  end
end
