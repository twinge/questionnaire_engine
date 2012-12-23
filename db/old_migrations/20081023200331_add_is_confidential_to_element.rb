class AddIsConfidentialToElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :is_confidential, :boolean
  end

  def self.down
    remove_column Element.table_name, :is_confidential
  end
end
