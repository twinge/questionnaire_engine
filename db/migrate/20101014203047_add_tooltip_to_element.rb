class AddTooltipToElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :tooltip, :text
  end

  def self.down
    remove_column Element.table_name, :tooltip
  end
end
