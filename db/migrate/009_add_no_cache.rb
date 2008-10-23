class AddNoCache < ActiveRecord::Migration
  def self.up
    add_column Page.table_name, :no_cache, :boolean, :default => 0
  end

  def self.down
    remove_column Page.table_name, :no_cache
  end
end
