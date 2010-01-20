class AddHiddenToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :hidden, :boolean, :default => false
    change_column :pages, :label, :string, :limit => 100
  end

  def self.down
    change_column :pages, :label, :string, :limit => 60
    remove_column :pages, :hidden
  end
end
