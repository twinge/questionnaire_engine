class AddAttachmentFieldsToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :size, :integer
    add_column :answers, :content_type, :string
    add_column :answers, :filename, :string
    add_column :answers, :height, :integer
    add_column :answers, :width, :integer
    add_column :answers, :parent_id, :integer
    add_column :answers, :thumbnail, :string
  end

  def self.down
    remove_column :answers, :thumbnail
    remove_column :answers, :parent_id
    remove_column :answers, :width
    remove_column :answers, :height
    remove_column :answers, :filename
    remove_column :answers, :content_type
    remove_column :answers, :size
  end
end
