class ReferenceSheet < AnswerSheet
  include Rails.application.routes.url_helpers
  set_table_name "#{Questionnaire.table_name_prefix}references"
  set_inheritance_column 'fake'
  
  belongs_to :question, :class_name => 'Element', :foreign_key => 'question_id'
  belongs_to :applicant_answer_sheet, :class_name => Questionnaire.answer_sheet_class, :foreign_key => "applicant_answer_sheet_id"
  before_create :generate_access_key
  
  alias_method :applicant, :applicant_answer_sheet
  def generate_access_key
    self.access_key = Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s)
  end
  
  def email_sent?() !self.email_sent_at.nil? end
  
  # send email invite
  def send_invite    
    return if self.email.blank?   # bypass blanks for now
    
    application = self.applicant_answer_sheet
    
    Notifier.deliver_notification(self.email,
                                  Questionnaire.from_email, 
                                  "Reference Invite", 
                                  {'reference_full_name' => self.name, 
                                   'applicant_full_name' => application.name,
                                   'applicant_email' => application.email, 
                                   'applicant_home_phone' => application.phone, 
                                   'reference_url' => edit_reference_sheet_url(self, :a => self.access_key, :host => ActionMailer::Base.default_url_options[:host])})
    true
  end
  
  def name
    [first_name, last_name].join(' ')
  end
end

