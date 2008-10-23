class CreateElements < ActiveRecord::Migration

  def self.up
    create_table Element.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :page_id, :integer, :null => false
      t.column :kind, :string, :limit => 40, :null => false     # single table inheritance: class name
      t.column :style, :string, :limit => 40    # render style

      t.column :label, :string, :limit => 255   # question label, section heading
      t.column :content, :text, :null => true   # for content/instructions, and for choices (one per line)
      
      t.column :required, :boolean                        # question is required?
      t.column :slug, :string, :limit => 36               # variable reference
      t.column :position, :integer, :null => false
      
      # foreign keys
      t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
      t.foreign_key :page_id, Page.table_name, :id
    end
  
    add_index Element.table_name, :slug
    add_index Element.table_name, [:question_sheet_id, :position, :page_id]
  end

  def self.down
    drop_table Element.table_name
  end
  
end
