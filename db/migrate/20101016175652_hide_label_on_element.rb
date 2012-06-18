class HideLabelOnElement < ActiveRecord::Migration
  def self.up
    add_column :qe_elements, :hide_label, 				:boolean, :default => false, :nil => false
    add_column :qe_elements, :hide_option_labels, :boolean, :default => false, :nil => false
  end

  def self.down
    remove_column :qe_elements, :hide_label
    remove_column :qe_elements, :hide_option_labels
  end
end