class SpMinistryFocus < ActiveRecord::Base
  unloadable
  has_and_belongs_to_many :sp_projects, :join_table => "sp_ministry_focuses_projects"
end
