class AddMaxLengthToElement < ActiveRecord::Migration
  def self.up
    add_column :qe_elements, :max_length, :integer
  end

  def self.down
    remove_column :qe_elements, :max_length
  end
end
