class AddHiddenToPage < ActiveRecord::Migration
  def self.up
    add_column :qe_pages, :hidden, :boolean, :default => false
    change_column :qe_pages, :label, :string, :limit => 100
  end

  def self.down
    change_column :qe_pages, :label, :string, :limit => 60
    remove_column :qe_pages, :hidden
  end
end
