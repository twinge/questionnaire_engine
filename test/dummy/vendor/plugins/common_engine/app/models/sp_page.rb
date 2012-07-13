class SpPage < Page
  unloadable
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "Person", :foreign_key => "updated_by_id"
end
