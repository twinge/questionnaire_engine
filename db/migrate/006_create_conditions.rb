class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table Condition.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :trigger_id, :integer, :null => false
      t.column :expression, :string, :limit => 255, :null => false
      t.column :toggle_page_id, :integer, :null => false
      t.column :toggle_id, :integer, :null => true        # null if toggles whole page
      
      # foreign keys
      t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
      t.foreign_key :trigger_id, Element.table_name, :id
      t.foreign_key :toggle_page_id, Page.table_name, :id
      t.foreign_key :toggle_id, Element.table_name, :id
    end
    
  end

  def self.down
    drop_table Condition.table_name
  end
end
