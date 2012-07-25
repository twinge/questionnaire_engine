class AddArchivedToQuestionSheet < ActiveRecord::Migration
  def self.up
    add_column Qe::QuestionSheet.table_name, :archived, :boolean, :default => false, :nil => false
  end

  def self.down
    remove_column Qe::QuestionSheet.table_name, :archived
  end
end
