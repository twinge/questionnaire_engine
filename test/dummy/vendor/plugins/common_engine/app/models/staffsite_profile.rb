# == Schema Information
# Schema version: 17
#
# Table name: staffsite_staffsiteprofile
#
#  StaffSiteProfileID :integer(10)   not null
#  firstName          :string(64)    
#  lastName           :string(64)    
#  userName           :string(64)    
#  changePassword     :boolean(1)    
#  captureHRinfo      :boolean(1)    
#  accountNo          :string(64)    
#  isStaff            :boolean(1)    
#  email              :string(64)    
#  passwordQuestion   :string(64)    
#  passwordAnswer     :string(64)    
#

class StaffsiteProfile < ActiveRecord::Base
  set_table_name "staffsite_staffsiteprofile"
  set_primary_key "StaffSiteProfileID"
  
  def full_name
    first_name.to_s  + " " + last_name.to_s
  end

  # an alias for firstName using standard ruby/rails conventions
  def first_name
    firstName
  end

  # an alias for lastName using standard ruby/rails conventions
  def last_name
    lastName
  end
end
