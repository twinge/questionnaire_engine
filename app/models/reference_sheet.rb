class ReferenceSheet < AnswerSheet
  set_table_name "#{Questionnaire.table_name_prefix}references"
  set_inheritance_column 'fake'
  
  belongs_to :question
  belongs_to :applicant_answer_sheet, :class_name => "AnswerSheet", :foreign_key => "applicant_answer_sheet_id"
  before_create :generate_access_key
  
  def generate_access_key
    self.access_key = Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s) + '_' + Digest::SHA2.hexdigest((object_id + Time.now.to_i).to_s)
  end
  
  def email_sent?() !self.email_sent_at.nil? end
  
  # send email invite
  def send_invite    
    return if self.email.blank?   # bypass blanks for now
    
    application = self.applicant_answer_sheet
    
    # Notifier.deliver_notification(self.email,
    #                               Questionnaire.from_email, 
    #                               "Reference Invite", 
    #                               {'reference_full_name' => self.name, 
    #                                'applicant_full_name' => application.applicant.informal_full_name,
    #                                'applicant_email' => application.applicant.email, 
    #                                'applicant_home_phone' => application.applicant.current_address.homePhone, 
    #                                'reference_url' => edit_application_reference_url(application, self.token, :host => ActionMailer::Base.default_url_options[:host])})
    true
  end
end

