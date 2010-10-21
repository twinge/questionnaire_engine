class Notifier < ActionMailer::Base

  # call Notifier.deliver_notification
  def notification(p_recipients, p_from, template_name, template_params)
    email_template = EmailTemplate.find_by_name(template_name)
  
    if email_template.nil?
      raise "Email Template #{template_name} could not be found"
    else
      @recipients = p_recipients
      @from = p_from
      @subject = Liquid::Template.parse(email_template.subject).render(template_params)
      @body = Liquid::Template.parse(email_template.content).render(template_params)
    end
  end
end
