class CreateAnswerSheets < ActiveRecord::Migration
  def self.up
    create_table AnswerSheet.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :completed_at, :datetime, :null => true        # null if incomplete
      
      # foreign keys
      t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
    end
  end

  def self.down
    drop_table AnswerSheet.table_name
  end
end
