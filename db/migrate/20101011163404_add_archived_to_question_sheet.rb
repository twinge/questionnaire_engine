class AddArchivedToQuestionSheet < ActiveRecord::Migration
  def self.up
    add_column :question_sheets, :archived, :boolean, :default => false, :nil => false
  end

  def self.down
    remove_column :question_sheets, :archived
  end
end
