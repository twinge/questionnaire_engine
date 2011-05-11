class AssociateAnswerSheetWithPerson < ActiveRecord::Migration
  def up
    drop_table AnswerSheetQuestionSheet.table_name
    add_column AnswerSheet.table_name, :person_id, :integer
    create_table Person.table_name, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.timestamps
    end
  end

  def down
    create_table AnswerSheetQuestionSheet.table_name, :force => true do |t|
      t.integer  "answer_sheet_id"
      t.integer  "question_sheet_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    drop_table Person.table_name
  end
end