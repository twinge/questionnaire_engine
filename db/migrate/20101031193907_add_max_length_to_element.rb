class AddMaxLengthToElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :max_length, :integer
  end

  def self.down
    remove_column Element.table_name, :max_length
  end
end
