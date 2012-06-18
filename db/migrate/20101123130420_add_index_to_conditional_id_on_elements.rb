class AddIndexToConditionalIdOnSpElements < ActiveRecord::Migration
  def self.up
    add_index :qe_elements, :conditional_id
    add_index :qe_elements, :question_grid_id
  end

  def self.down
    remove_index :qe_elements, :question_grid_id
    remove_index :qe_elements, :conditional_id
  end
end