class CreateQeReferenceSheets < ActiveRecord::Migration
  def change

    if table_exists?(:reference_sheets)
      rename_table(:reference_sheets, Qe::QuestionSheet.table_name)
    else
      create_table Qe::ReferenceSheet.table_name do |t|
        t.integer :question_id
        t.integer :applicant_answer_sheet_id
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
    end
    add_column Qe::Element.table_name, :related_question_sheet_id, :integer
  end
end
