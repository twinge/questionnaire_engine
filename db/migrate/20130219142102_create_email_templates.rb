class CreateEmailTemplates < ActiveRecord::Migration
  
  def up
    if table_exists?(:email_templates)
      rename_table(:email_templates, Qe::EmailTemplate.table_name)
    else
      create_table Qe::EmailTemplate.table_name do |t|
        t.string  :name,    :limit => 1000, :null => false
        t.text    :content
        t.boolean :enabled
        t.string  :subject
        
        t.timestamps
      end
      add_index Qe::EmailTemplate.table_name, :name
    end
  end

  def down
    remove_table(Qe::EmailTemplate.table_name)
  end

end
