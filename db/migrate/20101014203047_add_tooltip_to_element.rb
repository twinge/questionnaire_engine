class AddTooltipToElement < ActiveRecord::Migration
  def self.up
    add_column :qe_elements, :tooltip, :text
  end

  def self.down
    remove_column :qe_elements, :tooltip
  end
end
