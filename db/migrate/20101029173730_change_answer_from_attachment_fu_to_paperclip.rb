class ChangeAnswerFromAttachmentFuToPaperclip < ActiveRecord::Migration
  def self.up
    rename_column :qe_answers, :size,         :attachment_file_size
    rename_column :qe_answers, :filename,     :attachment_file_name
    rename_column :qe_answers, :content_type, :attachment_content_type
    add_column    :qe_answers, :attachment_updated_at, :datetime
    remove_column :qe_answers, :height
    remove_column :qe_answers, :width
    remove_column :qe_answers, :parent_id
    remove_column :qe_answers, :thumbnail
  end

  def self.down
    add_column :qe_answers, :height, :integer
    add_column :qe_answers, :width, :integer
    add_column :qe_answers, :parent_id, :integer
    add_column :qe_answers, :thumbnail, :string
    remove_column :qe_answers, :attachment_updated_at
    rename_column :qe_answers, :attachment_file_size,     :size
    rename_column :qe_answers, :attachment_file_name,     :filename
    rename_column :qe_answers, :attachment_content_type,  :content_type
  end
end