class AddAttachmentFieldsToAnswer < ActiveRecord::Migration
  def self.up
    add_column Answer.table_name, :size, :integer
    add_column Answer.table_name, :content_type, :string
    add_column Answer.table_name, :filename, :string
    add_column Answer.table_name, :height, :integer
    add_column Answer.table_name, :width, :integer
    add_column Answer.table_name, :parent_id, :integer
    add_column Answer.table_name, :thumbnail, :string
  end

  def self.down
    remove_column Answer.table_name, :thumbnail
    remove_column Answer.table_name, :parent_id
    remove_column Answer.table_name, :width
    remove_column Answer.table_name, :height
    remove_column Answer.table_name, :filename
    remove_column Answer.table_name, :content_type
    remove_column Answer.table_name, :size
  end
end
