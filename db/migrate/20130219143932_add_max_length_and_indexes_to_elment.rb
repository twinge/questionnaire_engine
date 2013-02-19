class AddMaxLengthAndIndexesToElment < ActiveRecord::Migration
  def change
    add_column Qe::Element.table_name, :max_length, :integer

    add_index Qe::Element.table_name, :conditional_id
    add_index Qe::Element.table_name, :question_grid_id
  end
end
