class AddIndexToConditionalIdOnElements < ActiveRecord::Migration
  
	# def self.up
	# end

	# def self.down
	# end

  def self.up
    add_index Qe::Element.table_name, :conditional_id
    add_index Qe::Element.table_name, :question_grid_id
  end

  def self.down
    remove_index Qe::Element.table_name, :question_grid_id
    remove_index Qe::Element.table_name, :conditional_id
  end
end