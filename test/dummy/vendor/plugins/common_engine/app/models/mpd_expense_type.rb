class MpdExpenseType < ActiveRecord::Base
  unloadable
  has_many :mpd_expenses
end
