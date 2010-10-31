class ChangeAnswerFromAttachmentFuToPaperclip < ActiveRecord::Migration
  def self.up
    rename_column Answer.table_name, :size, :attachment_file_size
    rename_column Answer.table_name, :filename, :attachment_file_name
    rename_column Answer.table_name, :content_type, :attachment_content_type
    add_column Answer.table_name, :attachment_updated_at, :datetime
    remove_column Answer.table_name, :height
    remove_column Answer.table_name, :width
    remove_column Answer.table_name, :parent_id
    remove_column Answer.table_name, :thumbnail
  end

  def self.down
    add_column Answer.table_name, :height, :integer
    add_column Answer.table_name, :width, :integer
    add_column Answer.table_name, :parent_id, :integer
    add_column Answer.table_name, :thumbnail, :string
    remove_column Answer.table_name, :attachment_updated_at
    rename_column Answer.table_name, :attachment_file_size, :size
    rename_column Answer.table_name, :attachment_file_name, :filename
    rename_column Answer.table_name, :attachment_content_type, :content_type
  end
end