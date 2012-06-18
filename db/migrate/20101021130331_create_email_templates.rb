class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table Qe::EmailTemplate.table_name, :force => true do |t|
      t.string  "name",    :limit => 1000, :null => false
      t.text    "content"
      t.boolean "enabled"
      t.string  "subject"
      t.timestamps
    end
    add_index Qe::EmailTemplate.table_name, :name
  end

  def self.down
    remove_index  Qe::EmailTemplate.table_name, :name
    drop_table    Qe::EmailTemplate.table_name
  end
end
