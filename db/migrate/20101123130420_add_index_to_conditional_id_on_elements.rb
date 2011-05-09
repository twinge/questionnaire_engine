class AddIndexToConditionalIdOnElements < ActiveRecord::Migration
  def self.up
    add_index Element.table_name, :conditional_id
    add_index Element.table_name, :question_grid_id
  end

  def self.down
    remove_index Element.table_name, :question_grid_id
    remove_index Element.table_name, :conditional_id
  end
end