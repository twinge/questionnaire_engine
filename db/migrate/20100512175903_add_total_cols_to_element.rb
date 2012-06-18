class AddTotalColsToElement < ActiveRecord::Migration
  def self.up
    add_column Qe::Element.table_name, :total_cols, :string
  end

  def self.down
    remove_column Qe::Element.table_name, :total_cols
  end
end
