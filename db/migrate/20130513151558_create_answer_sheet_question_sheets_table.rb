class CreateAnswerSheetQuestionSheetsTable < ActiveRecord::Migration
  def change
    if table_exists?(:qe_answer_sheet_question_sheets)
      rename_table(:qe_answer_sheet_question_sheets, Qe::AnswerSheetQuestionSheet.table_name)
    else
      create_table Qe::AnswerSheetQuestionSheet.table_name do |t|
        t.integer :answer_sheet_id
        t.integer :question_sheet_id

        t.timestamps
      end
    end
  end
end
