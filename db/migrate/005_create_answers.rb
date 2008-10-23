class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table Answer.table_name do |t|
      t.column :answer_sheet_id, :integer, :null => false
      t.column :question_id, :integer, :null => false
      t.column :value, :text
      t.column :short_value, :string, :null => true, :limit => 255   # indexed copy of :response
      
      # foreign keys
      t.foreign_key :answer_sheet_id, AnswerSheet.table_name, :id
      t.foreign_key :question_id, Element.table_name, :id
    end
    
    add_index Answer.table_name, :short_value
  end

  def self.down
    drop_table Answer.table_name
  end
end
