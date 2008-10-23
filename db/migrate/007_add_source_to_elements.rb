class AddSourceToElements < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :source, :string
    add_column Element.table_name, :value_xpath, :string
    add_column Element.table_name, :text_xpath, :string
  end

  def self.down
    remove_column Element.table_name, :source
    remove_column Element.table_name, :value_xpath
    remove_column Element.table_name, :text_xpath
  end
end
