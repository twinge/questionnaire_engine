# DateField
# - a question that provides a calendar/date picker

class DateField < Question
  
  def validation_class(answer_sheet)
    if self.style == 'mmyy'
      'validate-selection ' + super
    else
      'validate-date ' + super
    end
  end
  
  def response(app=nil)
    r = super
    return nil if r.blank?
    begin
      if r.is_a?(String)
        parts = r.split('/')
        if parts.length == 3
          r = Time.mktime(parts[2], parts[0], parts[1]) 
        else
          r = Time.parse(r)
        end
      end
    rescue ArgumentError
      r = ''
    end
    r
  end
  
  def display_response(app=nil)
    return format_date_response(app)
  end
  
  def format_date_response(app=nil)
    r = response(app)
    r = r.strftime("%m/%d/%Y") unless r.blank?
    r
  end
  
  # which view to render this element?
  def ptemplate
    if self.style == 'mmyy'
      'date_field_mmyy'
    else
      'date_field'
    end
  end
  
end

