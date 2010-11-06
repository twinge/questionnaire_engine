class HideLabelOnElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :hide_label, :boolean, :default => false, :nil => false
    add_column Element.table_name, :hide_option_labels, :boolean, :default => false, :nil => false
  end

  def self.down
    remove_column Element.table_name, :hide_label
    remove_column Element.table_name, :hide_option_labels
  end
end