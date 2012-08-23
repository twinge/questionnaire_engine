class AllowAnswerSheetQuestionSheetIdToBeNull < ActiveRecord::Migration
  def up
  	change_column Qe::AnswerSheet.table_name, :question_sheet_id, :integer, :null => true
  end

  def down
  	change_column Qe::AnswerSheet.table_name, :question_sheet_id, :integer, :null => false
  end
end
