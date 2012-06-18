class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :qe_email_templates, :force => true do |t|
      t.string  "name",    :limit => 1000, :null => false
      t.text    "content"
      t.boolean "enabled"
      t.string  "subject"
      t.timestamps
    end
    add_index :qe_email_templates, :name
  end

  def self.down
    remove_index  :qe_email_templates, :name
    drop_table    :qe_email_templates
  end
end
