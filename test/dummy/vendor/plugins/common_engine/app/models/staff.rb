class Staff < ActiveRecord::Base
  unloadable
  set_table_name "ministry_staff"
  set_primary_key "accountNo"
  belongs_to  :person
  
  def self.get_staff(ssm_id)
    if ssm_id.nil? then raise "nil ssm_id!" end
    ssm_user = User.find(:first, :conditions => ["userID = ?", ssm_id])
    if ssm_user.nil? then raise "ssm_id doesn't exist: #{ssm_id}" end
    person = ssm_user.person
    staff = person.staff
  end
  
  # "first_name last_name"
  def full_name
    firstName.to_s  + " " + lastName.to_s
  end

  def informal_full_name
    nickname.to_s  + " " + lastName.to_s
  end
  
  def nickname
    (!preferredName.to_s.strip.empty?) ? preferredName : firstName
  end
end
