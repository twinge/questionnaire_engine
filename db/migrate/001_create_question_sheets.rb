class CreateQuestionSheets < ActiveRecord::Migration

  def self.up
    create_table QuestionSheet.table_name do |t|
      t.column :label, :string, :limit => 60, :null => false   # name used internally in admin
    end
  end

  def self.down
    drop_table QuestionSheet.table_name
  end
  
end
