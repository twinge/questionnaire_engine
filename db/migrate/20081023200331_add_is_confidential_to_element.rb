class AddIsConfidentialToElement < ActiveRecord::Migration
  def self.up
    add_column :elements, :is_confidential, :boolean
  end

  def self.down
    remove_column :elements, :is_confidential
  end
end
