class AddHiddenToPage < ActiveRecord::Migration
  def self.up
    add_column Page.table_name, :hidden, :boolean, :default => false
    change_column Page.table_name, :label, :string, :limit => 100
  end

  def self.down
    change_column Page.table_name, :label, :string, :limit => 60
    remove_column Page.table_name, :hidden
  end
end
