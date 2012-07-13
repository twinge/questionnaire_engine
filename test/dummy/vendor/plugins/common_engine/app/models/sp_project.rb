require 'google_geocode'
class SpProject < ActiveRecord::Base
  unloadable
  acts_as_versioned
  
  STAFF = 'Staff'
  VOLUNTEER = 'Volunteer'
  KID = 'Kid'

  belongs_to :pd, :class_name => "Person", :foreign_key => "pd_id"
  belongs_to :apd, :class_name => "Person", :foreign_key => "apd_id"
  belongs_to :opd, :class_name => "Person", :foreign_key => "opd_id"
  belongs_to :coordinator, :class_name => "Person", :foreign_key => "coordinator_id"
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "Person", :foreign_key => "updated_by_id"
  
  
  has_many   :stats, :class_name => "SpStat", :foreign_key => "project_id"
  belongs_to :primary_ministry_focus, :class_name => 'SpMinistryFocus', :foreign_key => :primary_ministry_focus_id
  has_and_belongs_to_many :ministry_focuses, :class_name => 'SpMinistryFocus', :join_table => "sp_ministry_focuses_projects"
  has_many :sp_staff, :class_name => "SpStaff", :foreign_key => "project_id"
  has_many :staff, :through => :sp_staff, :source => :person, :conditions => "type = '#{STAFF}' AND year = #{SpApplication::YEAR}"
  has_many :volunteers, :through => :sp_staff, :source => :person, :conditions => "type = '#{VOLUNTEER}' AND year = #{SpApplication::YEAR}"
  has_many :kids, :through => :sp_staff, :source => :person, :conditions => "type = '#{KID}' AND year = #{SpApplication::YEAR}"
  has_many :project_versions, :class_name => "SpProjectVersion", :foreign_key => "sp_project_id"
  
  
  has_many :sp_applications, :dependent => :nullify, :foreign_key => :project_id

  validates_presence_of :name, :city, :country, :aoa, :display_location,
                        :primary_partner, :report_stats_to

#  validates_presence_of :start_date, :end_date,
#                        :primary_ministry_focus_id, :description,
#                        :operating_business_unit, :operating_operating_unit,
#                        :operating_department, :operating_designation,
#                        :scholarship_business_unit, :scholarship_operating_unit,
#                        :scholarship_department, :scholarship_designation,
#                        :student_cost
  validates_presence_of  :apply_by_date, :if => :use_provided_application
  validates_presence_of  :state, :if => Proc.new { |project| !project.is_wsn? } #:is_wsn?

  validates_inclusion_of :max_student_men_applicants, :in=>1..100, :message => "can't be 0 or greater than 100"
  validates_inclusion_of :max_student_women_applicants, :in=>0..100, :message => "can't be less than 0 or greater than 100"
  validates_inclusion_of :ideal_staff_men, :in=>1..100, :message => "can't be 0 or greater than 100"
  validates_inclusion_of :ideal_staff_women, :in=>0..100, :message => "can't be less than 0 or greater than 100"
  
  validates_uniqueness_of :name

  named_scope :with_partner, proc {|partner_scope| {:conditions => partner_scope}}
  named_scope :show_on_website, {:conditions => "show_on_website is true"}
  named_scope :current, {:conditions => {:project_status => 'open', :year => SpApplication::YEAR}}
  
  @@regions = {}

  def validate
    if partner_region_only && (primary_partner.length != 2 && secondary_partner.length != 2)
      errors.add_to_base("You must choose a regional partnership if you want to accept from Partner Region only.")
    end
  end

  def close!
    update_attribute('project_status', 'closed')
  end
  def open!
    update_attribute('project_status', 'open')
    update_attribute('year', SpApplication::YEAR)
  end

  def url=(val)
    super
    # We allow the user to enter a free-form url. I want to make sure it gets saved
    # with an http:// on it.
    if val && !val.strip.empty? && !(/^http/ =~ val)
      self[:url] = "http://" + val
    end
  end

  def before_create
    self[:project_status] = 'open'
  end

  def before_save
    get_coordinates
    calculate_weeks
  end

  def calculate_weeks
    if start_date && end_date
      self[:weeks] = ((end_date - start_date) / 1.week).round
    end
  end
  def is_wsn?
    return country != 'United States'
  end

  # helper methods for xml feed
  def pd_name_non_secure
    pd.informal_full_name if pd
  end
  
  def pd_name
    pd_name_non_secure if (country_status == 'open' && pd && !pd.is_secure?)
  end

  def apd_name_non_secure
    apd.informal_full_name if apd
  end
  
  def apd_name
    apd_name_non_secure if (country_status == 'open' && apd && !apd.is_secure?)
  end

  def pd_email_non_secure
    pd.current_address.email if pd && pd.current_address
  end

  def pd_email
    pd_email_non_secure if (country_status == 'open' && pd && !pd.is_secure?)
  end

  def apd_email_non_secure
    apd.current_address.email if apd && apd.current_address
  end

  def apd_email
    apd_email_non_secure if (country_status == 'open' && apd && !apd.is_secure?)
  end

  def primary_focus_name
    primary_ministry_focus.name if primary_ministry_focus
  end

  def regional_info
    if primary_partner && region = SpProject.get_region(primary_partner)
      info =  region.name + ' Regional Office: Phone - ' + region.sp_phone
      info += ', Email - ' + region.email if region.email && !region.email.empty?
      info
    end
  end

  def self.get_region(region)
    @@regions[region] ||= Region.find_by_region(region)
  end

  def country_status
    @country_status ||=
    begin
      country = Country.find_by_country(self.country)
      country && country.closed? ? 'closed' : 'open'
    end
  end

  def self.send_leader_reminder_emails
    projects = SpProject.find(:all,
    :select => "project.*",
    :conditions => ["app.status IN(?) and app.year = ? and project.start_date > ?", SpApplication.ready_statuses, SpApplication::YEAR, Time.now],
    :joins => "as project inner join sp_applications app on (app.current_project_queue_id = project.id)",
    :group => "project.id")
    projects.each do |project|
      if (project.pd || project.apd)
        SpProjectMailer.deliver_leader_reminder(project)
      end
    end
  end

  def self.send_stats_reminder_emails
    campus_ministry_types = ['Campus Ministry - US summer project', 'Campus Ministry - WSN summer project']
    projects = SpProject.find(:all,
      :select => "project.*, stat.id as stat_id",
      :conditions => ["project.report_stats_to in (?) and project.project_status = ?", campus_ministry_types, 'open'],
      :joins => "as project left join sp_stats stat on (stat.project_id = project.id and stat.year = project.year)")
    #at some point, may also need to search SpProjectVersions

    projects.each do |project|
      date_to_start = Time.parse('8/15/' + project.year.to_s)
      if (Time.now > date_to_start && project.stat_id.nil?)
        if (project.pd && project.pd.email_address)
          SpProjectMailer.deliver_stats_reminder(project)
        end
      end
    end
  end

  # This method uses google geocodes to get longitude/latitude coordinates for
  # a project.
  # http://maps.google.com/maps/geo?q=orlando,FL&output=xml&key=ABQIAAAA3_Rt6DOXqoqzxOdrpwwtvhSTzVfmYDnwpEGk65AEA3VA32K1ZBTjPtznyT3qg_teDdJYQqkNfMwI7w
  def get_coordinates
    if self.country_status == 'closed'
      self.latitude = nil
      self.longitude = nil
    else
      key = 'ABQIAAAA3_Rt6DOXqoqzxOdrpwwtvhSTzVfmYDnwpEGk65AEA3VA32K1ZBTjPtznyT3qg_teDdJYQqkNfMwI7w'
      q = self.city || ''
      q += ','+self.state if self.state
      q += ','+self.country
      q.gsub!(' ','+')
      gg = GoogleGeocode.new key
      begin
        location = gg.locate q
        self.latitude = location.coordinates[0]
        self.longitude = location.coordinates[1]
        # We need to make sure that that no 2 projects have exactly the same
        # coordinates. If they do, they will overlap on the flash map and
        # you won't be able to click on one of them.
        while SpProject.find(:first, :conditions => ['latitude = ? and longitude = ?', self.latitude, self.longitude])
          delta_longitude, delta_latitude = 0,0
          delta_longitude = rand(6) - 3 while delta_longitude.abs < 2
          delta_latitude = rand(6) - 3 while delta_latitude.abs < 2
          # move it over a little.
          self.longitude += delta_longitude.to_f/10
          self.latitude += delta_latitude.to_f/10
        end
      rescue GoogleGeocode::AddressError => e;
      rescue
      end
    end
  end
  
  def get_previous_year_records(version)
    versions = SpProjectVersion.find(:all, :conditions => ['sp_project_id = ? AND id IN (' + SpProject.build_search_project_id_string + ')', self.id], :order => :year)
    versions.reverse
  end
  
  def self.build_search_project_id_string
    string = ""
    query = "select max(id) as id from sp_project_versions group by sp_project_id, year order by max(id)"
    conn = SpProjectVersion.connection
    results = conn.select_all(query)
    results.each do |result|
      string += result["id"] + ", "
    end
    string.chomp(", ")
  end
end
