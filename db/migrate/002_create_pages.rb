class CreatePages < ActiveRecord::Migration
  def self.up
    create_table Page.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :label, :string, :limit => 60, :null => false    # page title
      t.column :number, :integer, :null => false                # page number (order)
      
      # foreign keys
      t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
    end
    
    add_index Page.table_name, [:question_sheet_id, :number], :name => "page_number", :unique => true
  end

  def self.down
    drop_table Page.table_name
  end
end

