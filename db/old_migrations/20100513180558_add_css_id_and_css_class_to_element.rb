class AddCssIdAndCssClassToElement < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :css_id, :string
    add_column Element.table_name, :css_class, :string
  end

  def self.down
    remove_column Element.table_name, :css_class
    remove_column Element.table_name, :css_id
  end
end
