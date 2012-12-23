class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table ReferenceSheet.table_name do |t|
      t.integer :question_id, :applicant_answer_sheet_id
      t.datetime :email_sent_at
      t.string :relationship
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :status
      t.datetime :submitted_at
      t.string :access_key
    
      t.timestamps
    end
    add_column Element.table_name, :related_question_sheet_id, :integer
  end

  def self.down
    remove_column Element.table_name, :related_question_sheet_id
    drop_table ReferenceSheet.table_name
  end
end