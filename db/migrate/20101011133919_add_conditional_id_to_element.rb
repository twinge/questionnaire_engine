class AddConditionalIdToElement < ActiveRecord::Migration
  def self.up
    add_column Qe::Element.table_name, :conditional_id, :integer
  end

  def self.down
    remove_column Qe::Element.table_name, :conditional_id
  end
end
