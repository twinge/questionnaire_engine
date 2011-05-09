class AssociateQuestionSheetWithQuestionnable < ActiveRecord::Migration
  def up
    add_column QuestionSheet.table_name, :questionnable_id, :integer
    add_column QuestionSheet.table_name, :questionnable_type, :string
    add_index QuestionSheet.table_name, [:questionnable_id, :questionnable_type], :name => "questionnable"
  end

  def down
    remove_column QuestionSheet.table_name, :questionnable_id, :integer
    remove_column QuestionSheet.table_name, :questionnable_type, :string
    remove_index QuestionSheet.table_name, [:questionnable_id, :questionnable_type], :name => "questionnable"
  end
end