class Person < ActiveRecord::Base 
  unloadable
  
  set_table_name   "ministry_person"
  set_primary_key  "personID"
  
  belongs_to              :user, :foreign_key => "fk_ssmUserId"  #Link it to SSM

  has_one                 :staff

  # Addresses
  has_one                 :current_address, :foreign_key => "fk_PersonID", :conditions => "addressType = 'current'", :class_name => 'Address'
  has_one                 :permanent_address, :foreign_key => "fk_PersonID", :conditions => "addressType = 'permanent'", :class_name => 'Address'
  has_one                 :emergency_address1, :foreign_key => "fk_PersonID", :conditions => "addressType = 'emergency1'", :class_name => 'Address'
  has_many                :addresses, :foreign_key => "fk_PersonID" 
  
  # Cru Commons
  has_many                :personal_links
  has_many                :group_messages
  has_many                :personal_messages      # not fully implemented
  has_and_belongs_to_many :friends, :uniq => true, :join_table => "am_friends_people"
  has_and_belongs_to_many :groups,  :uniq => true, :join_table => "am_groups_people"

  # On Campus Now
  has_many                :orders                 
  
  has_one                 :spouse, :foreign_key => "fk_spouseID"
  
  
  # STINT
  has_many                :hr_si_applications, :foreign_key => "fk_PersonID"
  has_many                :applies, :foreign_key => "applicant_id"   # applicants applying
  has_many                :apply_sheets    # whoever, filling in a sheet
  has_one                 :current_si_application, :foreign_key => "fk_PersonID", :conditions => "siYear = '#{HrSiApplication::YEAR}'", :class_name => 'HrSiApplication'
  
  # Summer Project
  has_many                :sp_applications
  has_one                 :current_application, :conditions => "year = '#{SpApplication::YEAR}'", :class_name => 'SpApplication'
    
  # General
  attr_accessor           :school
  
  # File Column
  file_column             :image, :fix_file_extensions => true,
                          :magick => { :size => '400x400!', :crop => '1:1',
                            :versions => {
                              :mini   => {:crop => '1:1', :size => "50x50!"},
                              :thumb  => {:crop => '1:1', :size => "100x100!"},
                              :medium => {:crop => '1:1', :size => "200x200!"}
                            }
                          }
                  
  validates_file_format_of :image, :in => ["image/jpeg", "image/gif"]
  validates_uniqueness_of :fk_ssmUserId, :message => "This username already has a person record!", :allow_nil => true
  validates_presence_of :first_name
  # validates_filesize_of :image, :in => 0..2.megabytes
  # 
  
  before_save :stamp
  
  def emergency_address
    emergency_address1
  end
  def emergency_address=(address)
    self.emergency_address1 = address
  end
  
# This code can cause an infinite recursion 
#  def region
#    self.region || self.target_area.region
#  end
  def campus=(campus_name)
    write_attribute("campus", campus_name)
    if target_area
      write_attribute("region", self.school.region)
    end
  end
  
  def target_area
    if (self.school)
      self.school
    else 
      if (campus? && universityState?)
        self.school = TargetArea.find(:first,
                    :conditions => ["name = ? AND state = ?", campus, universityState])
      elsif (campus?)
        self.school = TargetArea.find(:first,
                    :conditions => ["name = ?", campus])
      else
        self.school = nil
      end
    end
  end
  
  def validate_blogfeed
    errors.add(:blogfeed, "is invalid") if invalid_feed?
  end
  
  # empty_feed? checks to see if blogfeed has any characters that could be a feed
  def empty_feed?
    blogfeed ? blogfeed.strip.empty? : true  
  end
  
  def invalid_feed?
    FeedTools::Feed.open(blogfeed) unless empty_feed?
  rescue FeedTools::FeedAccessError
    flash[:notice] = "Invalid feed" if @my_entry
  rescue
    flash[:notice] = "Not well formed XML" if @my_entry and not empty_feed?
  end

  def human_gender
    return nil if gender.to_s.empty?
    return is_male? ? 'Male' : 'Female'
  end
  
  def is_male?
    return gender.to_i == 1
  end
  
  def is_high_school?
    return lastAttended == "HighSchool"
  end
  
  # "first_name last_name"
  def full_name
    first_name.to_s  + " " + last_name.to_s
  end
  
  # "nickname last_name"
  def informal_full_name
    nickname.to_s  + " " + last_name.to_s
  end
  
  # "first_name middle_name last_name"
  def long_name
    l = first_name.to_s + " "
    l += middle_name.to_s + " " if middle_name
    l += last_name.to_s
  end

  # an alias for firstName using standard ruby/rails conventions
  def first_name
    firstName
  end
                
  def first_name=(f)    
    write_attribute("firstName", f)
  end

  # an alias for middleName using standard ruby/rails conventions
  def middle_name
    middleName
  end
                
  def middle_name=(m)   
    write_attribute("middleName", m)
  end
  
  # an alias for lastName using standard ruby/rails conventions
  def last_name
    lastName
  end
                
  def last_name=(l)   
    write_attribute("lastName", l)
  end
  
  #a little more than an alias.  Nickname is the preferredName if one is listed.  Otherwise it is first name                  
  def nickname
    (preferredName and not preferredName.strip.empty?) ? preferredName : firstName
  end

  #nickname is an alias for preferredName               
  def nickname=(name)   
    write_attribute("preferredName", name)
  end
  
  # an alias for yearInSchool
  def year
    yearInSchool
  end
                
  def year=(y)  
    write_attribute("yearInSchool", y)
  end
  
  def marital_status
    Person::MARITAL_STATUSES[maritalStatus]
  end
  
  MARITAL_STATUSES = {'S' => 'Single', 
                      'M' => 'Married', 
                      'D' => 'Divorced',
                      'W' => 'Widowed',
                      'P' => 'Seperated'}
  
  #set dateChanged and changedBy
  def stamp
    self.dateChanged = Time.now
    self.changedBy = ApplicationController.application_name
  end
  
  include FileColumnHelper
  
  # file_column picture
  def pic(size = "mini")
    if image.nil?
      "/images/nophoto_" + size + ".gif"
    else
      url_for_file_column(self, "image", size)
    end
  end
  
  def mini_pic
    pic("mini")
  end
    
  def thumb_pic
    pic("thumb")
  end
    
  def med_pic
    pic("medium")
  end

  def email
    email_address
  end
  
  def email_address
    current_address.email if current_address
  end
  
  def phone
    current_address.phone_number if current_address
  end
  
  # This method shouldn't be needed because nightly updater should fill this in
  def is_secure?
    if staff
      (staff.isSecure == 'T' ? true : false)
    else
      false
    end
  end
  
  # Find an exact match by email
  def self.find_exact(person, address)
    # try by address first
    person = Person.find(:first, :conditions => ["#{Address.table_name}.email = ?", address.email], :include => :current_address)
    # then try by username
    person ||= Person.find(:first, :conditions => ["#{User.table_name}.username = ?", address.email], :include => :user)
    return person
  end

  # Make sure account numbers are 9 or 10 digits long
  def self.fix_acct_no(acct_no)
    result = acct_no
    if !acct_no.blank?
      fix_length = 9
      if acct_no.ends_with?("S") || acct_no.ends_with?("s")
        fix_length = 10
      end
      pad = fix_length - acct_no.length
      result = "0" * pad + acct_no if pad > 0
    end
    result
  end
end
