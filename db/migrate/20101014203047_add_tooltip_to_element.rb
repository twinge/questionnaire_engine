class AddTooltipToElement < ActiveRecord::Migration
  def self.up
    add_column Qe::Element.table_name, :tooltip, :text
  end

  def self.down
    remove_column Qe::Element.table_name, :tooltip
  end
end
