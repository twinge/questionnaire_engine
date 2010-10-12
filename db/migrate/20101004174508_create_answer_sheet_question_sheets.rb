class CreateAnswerSheetQuestionSheets < ActiveRecord::Migration
  def self.up
    create_table :answer_sheet_question_sheets do |t|
      t.integer :answer_sheet_id
      t.integer :question_sheet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_sheet_question_sheets
  end
end
