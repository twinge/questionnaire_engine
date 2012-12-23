class AddConditionalIdToElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :conditional_id, :integer
  end

  def self.down
    remove_column Element.table_name, :conditional_id
  end
end
