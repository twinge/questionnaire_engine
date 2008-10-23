class AddGridId < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :question_grid_id, :integer
    add_column Element.table_name, :cols, :string
  end

  def self.down
    remove_column Element.table_name, :question_grid_id
    remove_column Element.table_name, :cols
  end
end
