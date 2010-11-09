class QeInitial < ActiveRecord::Migration
  def self.up
    create_table QuestionSheet.table_name do |t|
      t.column :label, :string, :limit => 60, :null => false   # name used internally in admin
    end
    
    create_table Page.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :label, :string, :limit => 60, :null => false    # page title
      t.column :number, :integer                                # page number (order)
      
      # foreign keys
      # t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
    end
    
    create_table Element.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :page_id, :integer, :null => false
      t.column :kind, :string, :limit => 40, :null => false     # single table inheritance: class name
      t.column :style, :string, :limit => 40    # render style

      t.column :label, :string, :limit => 255   # question label, section heading
      t.column :content, :text, :null => true   # for content/instructions, and for choices (one per line)
      
      t.column :required, :boolean                        # question is required?
      t.column :slug, :string, :limit => 36               # variable reference
      t.column :position, :integer
      t.string :object_name, :attribute_name
      
      # foreign keys
      # t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
      # t.foreign_key :page_id, Page.table_name, :id
    end
  
    add_index Element.table_name, :slug
    add_index Element.table_name, [:question_sheet_id, :position, :page_id], :unique => false
    
    create_table AnswerSheet.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :completed_at, :datetime, :null => true        # null if incomplete
      
      # foreign keys
      # t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
    end
    
    create_table Answer.table_name do |t|
      t.column :answer_sheet_id, :integer, :null => false
      t.column :question_id, :integer, :null => false
      t.column :value, :text
      t.column :short_value, :string, :null => true, :limit => 255   # indexed copy of :response
      
      # foreign keys
      # t.foreign_key :answer_sheet_id, AnswerSheet.table_name, :id
      # t.foreign_key :question_id, Element.table_name, :id
    end
    
    add_index Answer.table_name, :short_value
    
    create_table Condition.table_name do |t|
      t.column :question_sheet_id, :integer, :null => false
      t.column :trigger_id, :integer, :null => false
      t.column :expression, :string, :limit => 255, :null => false
      t.column :toggle_page_id, :integer, :null => false
      t.column :toggle_id, :integer, :null => true        # null if toggles whole page
      
      # foreign keys
      # t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
      # t.foreign_key :trigger_id, Element.table_name, :id
      # t.foreign_key :toggle_page_id, Page.table_name, :id
      # t.foreign_key :toggle_id, Element.table_name, :id
    end
    
    add_column Element.table_name, :source, :string
    add_column Element.table_name, :value_xpath, :string
    add_column Element.table_name, :text_xpath, :string
    
    add_column Element.table_name, :question_grid_id, :integer
    add_column Element.table_name, :cols, :string
    
    add_column Page.table_name, :no_cache, :boolean, :default => 0
  end

  def self.down
    remove_column Page.table_name, :no_cache
    remove_column Element.table_name, :question_grid_id
    remove_column Element.table_name, :cols
    remove_column Element.table_name, :source
    remove_column Element.table_name, :value_xpath
    remove_column Element.table_name, :text_xpath
    drop_table Condition.table_name
    drop_table Answer.table_name
    drop_table AnswerSheet.table_name
    drop_table Element.table_name
    drop_table Page.table_name
    drop_table QuestionSheet.table_name
  end
end
