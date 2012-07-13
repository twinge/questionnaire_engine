require 'digest/md5'
class SpApplication < ActiveRecord::Base
  COST_BEFORE_DEADLINE = 25
  COST_AFTER_DEADLINE = 35
  
  unloadable
  acts_as_state_machine :initial => :started, :column => :status

  # State machine stuff
  state :started
  state :submitted, :enter => Proc.new {|app|
                                logger.info("application #{app.id} submitted")
                                SpApplicationMailer.deliver_submitted(app)
                                app.submitted_at = Time.now
                              }

  state :completed, :enter => Proc.new {|app|
                                logger.info("application #{app.id} completed")
                                app.completed_at = Time.now
                                app.add_to_project_queue
                                SpApplicationMailer.deliver_completed(app)
                                logger.info("Application #{app.id} completed; placed in project #{app.current_project_queue_id}'s queue")
                              }

  state :unsubmitted, :enter => Proc.new {|app|
                                app.unsubmit_email
                                app.remove_from_project_queue
                              }

  state :withdrawn, :enter => Proc.new {|app|
                                logger.info("application #{app.id} withdrawn")
                                SpApplicationMailer.deliver_withdrawn(app) if app.email_address
                                app.remove_from_project_queue
                                app.remove_from_project_assignment
                                app.withdrawn_at = Time.now
                              }

  state :accepted_as_intern, :enter => Proc.new {|app|
                                logger.info("application #{app.id} accepted as intern")
                                app.accepted_at = Time.now
                                if app.project_id.nil?
                                  app.project_id = app.preference1_id if app.preference1_id
                                  app.project_id = app.current_project_queue_id if app.current_project_queue_id
                                end
                                # MpdUser.create(:ssm_id => app.person.fk_ssmUserId)
                             }

  state :accepted_as_participant, :enter => Proc.new {|app|
                                logger.info("application #{app.id} accepted as participant")
                                app.accepted_at = Time.now
                                if app.project_id.nil?
                                  app.project_id = app.preference1_id if app.preference1_id
                                  app.project_id = app.current_project_queue_id if app.current_project_queue_id
                                end
                                # MpdUser.create(:ssm_id => app.person.fk_ssmUserId)
                             }

  state :declined, :enter => Proc.new {|app|
                                logger.info("application #{app.id} declined")
                                app.remove_from_project_queue
                                app.remove_from_project_assignment
                             }

  event :submit do
    transitions :to => :submitted, :from => :started
    transitions :to => :submitted, :from => :unsubmitted
    transitions :to => :submitted, :from => :withdrawn
    transitions :to => :submitted, :from => :completed
  end

  event :withdraw do
    transitions :to => :withdrawn, :from => :started
    transitions :to => :withdrawn, :from => :submitted
    transitions :to => :withdrawn, :from => :completed
    transitions :to => :withdrawn, :from => :unsubmitted
    transitions :to => :withdrawn, :from => :declined
    transitions :to => :withdrawn, :from => :accepted_as_intern
    transitions :to => :withdrawn, :from => :accepted_as_participant
  end

  event :unsubmit do
    transitions :to => :unsubmitted, :from => :submitted
    transitions :to => :unsubmitted, :from => :withdrawn
    transitions :to => :unsubmitted, :from => :completed
  end

  event :complete do
    transitions :to => :completed, :from => :submitted
    transitions :to => :completed, :from => :unsubmitted
    transitions :to => :completed, :from => :started
    transitions :to => :completed, :from => :withdrawn
    transitions :to => :completed, :from => :declined
    transitions :to => :completed, :from => :accepted_as_intern
    transitions :to => :completed, :from => :accepted_as_participant
  end

  event :accept_as_intern do
    transitions :to => :accepted_as_intern, :from => :completed
    transitions :to => :accepted_as_intern, :from => :started
    transitions :to => :accepted_as_intern, :from => :withdrawn
    transitions :to => :accepted_as_intern, :from => :declined
    transitions :to => :accepted_as_intern, :from => :submitted
    transitions :to => :accepted_as_intern, :from => :accepted_as_participant
  end

  event :accept_as_participant do
    transitions :to => :accepted_as_participant, :from => :completed
    transitions :to => :accepted_as_participant, :from => :started
    transitions :to => :accepted_as_participant, :from => :withdrawn
    transitions :to => :accepted_as_participant, :from => :declined
    transitions :to => :accepted_as_participant, :from => :submitted
    transitions :to => :accepted_as_participant, :from => :accepted_as_intern
  end

  event :decline do
    transitions :to => :declined, :from => :started
    transitions :to => :declined, :from => :submitted
    transitions :to => :declined, :from => :completed
    transitions :to => :declined, :from => :accepted_as_intern
    transitions :to => :declined, :from => :accepted_as_participant
  end

  belongs_to :person
  belongs_to :project, :class_name => 'SpProject', :foreign_key => :project_id
  has_many :sp_references, :class_name => 'SpReference', :order => "type", :foreign_key => :application_id
  has_one :sp_peer_reference, :class_name => 'SpPeerReference', :foreign_key => :application_id
  has_one :sp_spiritual_reference1, :class_name => 'SpSpiritualReference1', :foreign_key => :application_id
  has_one :sp_spiritual_reference2, :class_name => 'SpSpiritualReference2', :foreign_key => :application_id
  has_one :sp_parent_reference, :class_name => 'SpParentReference', :foreign_key => :application_id
  has_many :payments, :class_name => "SpPayment", :foreign_key => "application_id"
  belongs_to :preference1, :class_name => 'SpProject', :foreign_key => :preference1_id
  belongs_to :preference2, :class_name => 'SpProject', :foreign_key => :preference2_id
  belongs_to :preference3, :class_name => 'SpProject', :foreign_key => :preference3_id
  belongs_to :preference4, :class_name => 'SpProject', :foreign_key => :preference4_id
  belongs_to :preference5, :class_name => 'SpProject', :foreign_key => :preference5_id
  belongs_to :current_project_queue, :class_name => 'SpProject', :foreign_key => :current_project_queue_id
  has_many :answers, :foreign_key => :instance_id  do
    def by_question_id(q_id)
      self.detect {|a| a.question_id == q_id}
    end
  end
  has_one :evaluation, :class_name => 'SpEvaluation', :foreign_key => :application_id
  
  named_scope :for_year, proc {|year| {:conditions => {:year => year}}}
  named_scope :preferred_project, proc {|project_id| {:conditions => ["current_project_queue_id = ? OR preference1_id = ?", project_id, project_id], 
                                                      :include => :person }}

  before_create :set_su_code
  after_save :complete

  def validates
    if ((status == 'accepted_as_intern' || status == 'accepted_as_participant') && project_id.nil?)
      errors.add_to_base("You must specify which project you are accepting this applicant to.")
    end
  end

  YEAR = 2011
  
  DEADLINE1 = Time.parse((SpApplication::YEAR - 1).to_s + "/12/10");
  DEADLINE2 = Time.parse(SpApplication::YEAR.to_s + "/01/24");
  DEADLINE3 = Time.parse(SpApplication::YEAR.to_s + "/02/24");

  def deadline_met
    if completed_at
      if completed_at < DEADLINE1 + 1.day
        return 1
      end
      if completed_at < DEADLINE2 + 1.day
        return 2
      end
      if completed_at < DEADLINE3 + 1.day
        return 3
      end
    end
    return 0
  end
  
  def project_cost
    project.student_cost if project
  end

  # The statuses that mean an application has NOT been submitted
  def self.unsubmitted_statuses
    %w(started unsubmitted)
  end

  # The statuses that mean an applicant is NOT ready to evaluate
  def self.not_ready_statuses
    %w(submitted)
  end

  # The statuses that mean an applicant is NOT going
  def self.not_going_statuses
    %w(withdrawn declined)
  end

  # The statuses that mean an applicant IS ready to evaluate
  def self.ready_statuses
    %w(completed)
  end
  
  def self.accepted_statuses
    %w(accepted_as_intern accepted_as_participant)
  end

  def self.applied_statuses
    SpApplication.ready_statuses | SpApplication.accepted_statuses
  end
  
  # The statuses that mean an applicant's application is not completed, but still in progress
  def self.uncompleted_statuses
    %w(started submitted unsubmitted)
  end

  def self.statuses
    SpApplication.unsubmitted_statuses | SpApplication.not_ready_statuses | SpApplication.ready_statuses | SpApplication.accepted_statuses | SpApplication.not_going_statuses
  end
  
  def self.cost
    if Time.now < payment_deadline
      return COST_BEFORE_DEADLINE
    else
      return COST_AFTER_DEADLINE
    end
  end
  
  
  def self.payment_deadline
    Time.parse('2/25/'+SpApplication::YEAR.to_s+' 3:00')
  end

  def has_paid?
    return true if self.payments.detect(&:approved?)
    return false
  end

  def paid_at
    self.payments.each do |payment|
      return payment.updated_at if payment.approved?
    end
    return nil
  end
  
  def waive_fee!
    self.payments.create!(:status => "Approved", :payment_type => 'Waived')
    self.complete #Check to see if application is complete
  end

  def unsubmit_email
    SpApplicationMailer.deliver_unsubmitted(self)
  end

  def self.questionnaire()
    @@questionnaire ||= Questionnaire.find_by_id(1, :include => :pages, :order => 'sp_questionnaire_pages.position')
  end

  def complete(ref = nil)
    return false unless self.submitted?
    if person.lastAttended != "HighSchool"
      return false unless
                    (self.sp_peer_reference && (self.sp_peer_reference.completed? || self.sp_peer_reference == ref))
    end
    return false unless
                    (self.sp_spiritual_reference1 && (self.sp_spiritual_reference1.completed? || self.sp_spiritual_reference1 == ref))
    if self.apply_for_leadership?
      return false unless
                    (self.sp_spiritual_reference2 && (self.sp_spiritual_reference2.completed? || self.sp_spiritual_reference2 == ref))
    end
    if person.lastAttended == "HighSchool"
       return false unless
                    (self.sp_parent_reference && (self.sp_parent_reference.completed? || self.sp_parent_reference == ref))
    end
    return false unless self.has_paid?
    return self.complete!
  end

  def set_su_code
    self.su_code = Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s)
  end

  # The :frozen? method lets the QuestionnaireEngine know to not allow
  # the user to change the answer to a question.
  def frozen?
    !%w(started unsubmitted).include?(self.status)
  end

  def can_change_references?
    %w(started unsubmitted submitted).include?(self.status)
  end

  def available_date
    @available_date ||= get_answer(53)
  end

  def available_date=(val)
    save_answer(53, val)
  end

  def return_date
    @return_date ||= get_answer(54)
  end

  def return_date=(val)
    save_answer(54, val)
  end

  def check_email_frequency
    @check_email_frequency ||= get_answer(33)
  end

  def communication_preference
    @communication_preference ||= get_answer(34)
  end

  def health_insurance
    @health_insurance ||= get_answer(248)
  end

  def insurance_provider
    @insurance_provider ||= get_answer(249)
  end

  def insurance_policy_number
    @insurance_policy_number ||= get_answer(250)
  end

  def continuing_school?
    @continuing_school ||= is_true(get_answer(57)) ? "Yes" : "No"
  end
  
  def has_passport?
    @has_passport ||= is_true(get_answer(409)) ? "Yes" : "No"
  end

  def activities_on_campus
    @activities_on_campus ||= Element.find(65)
  end

  def ministries_on_campus
    @ministries_on_campus ||= Element.find(68)
  end
  
  def applying_for_internship
    @applying_for_internship ||= Element.find(98)
  end

  def willing_for_other_projects
    @willing_for_other_projects ||= Element.find(88)
  end

  def willing_for_other_projects_answer
    is_true(get_answer(88))
  end

  def willing_for_other_projects_answer=(val)
    save_answer(88, val)
  end

  def is_true(val)
    [1,'1',true,'true'].include?(val)
  end

  def get_answer(q_id)
    answer = get_answer_object(q_id)
    answer ? answer.answer.to_s : ''
  end

  def save_answer(q_id, val)
    answer = get_answer_object(q_id)
    if answer
      answer.answer = val
      answer.save!
    end
  end

  def get_answer_object(q_id)
    answers.detect {|a| a.question_id == q_id}
  end


  # When an applicant submits their application this method
  # assigns an applicant to a project queue corresponding to their
  # first preference or the assigned project and increments the 
  # number of men or women that have applied for that project.
  def add_to_project_queue
    id_to_add_to = self.preference1_id
    id_to_add_to ||= self.project_id
    self.current_project_queue_id = id_to_add_to
    project = self.current_project_queue
    if person.is_male?
      project.current_applicants_men += 1
    else
      project.current_applicants_women += 1
    end
    project.save(false)
    return project
  end

  # When an applicant unsubmits their application this method
  # removes the applicant from their project queue and
  # decrements the number of men or women that have applied
  # for that project.
  def remove_from_project_queue
    # We have to check to see if the status is 'completed' because this
    # callback hook will get called when an application is set to 'completed'
    # or 'unsubmitted', and we only want it to run for 'unsubmitted'
    project = self.current_project_queue
    self.current_project_queue_id = nil
    if project
      if person.is_male?
        project.increment(:current_applicants_men, -1)
      else
        project.increment(:current_applicants_women, -1)
      end
      project.save(false)
    end
    return project
  end

  # This method removes the applicant from their project queue and
  # project assignment (decrementing counts appropriately).
  def remove_from_project_assignment
    # We have to check to see if the status is 'completed' because this
    # callback hook will get called when an application is set to 'completed'
    # or 'unsubmitted', and we only want it to run for 'unsubmitted'
    project = self.project
    self.project_id = nil
    if project
      project.current_students_men -= 1 if person.is_male?
      project.current_students_women -= 1 unless person.is_male?
    project.save(false)
    end
    return project
  end

  def email_address
    person.current_address.email if person && person.current_address
  end

  def account_balance
    SpDonation.get_balance(designation_number)
  end


  def self.send_status_emails
    logger.info("Sending application reminder emails")
    uncompleted_apps = SpApplication.find(:all,
    :select => "app.*",
    :joins => "as app inner join sp_projects as proj on (proj.id = app.preference1_id)",
    :conditions => ["app.status in (?) and app.year = ? and proj.start_date > ?", SpApplication.uncompleted_statuses, SpApplication::YEAR, Time.now])
    uncompleted_apps.each do |app|
      if (app.person.informal_full_name && app.email_address && app.email_address != "")
        SpApplicationMailer.deliver_status(app)
      end
    end
  end
end
