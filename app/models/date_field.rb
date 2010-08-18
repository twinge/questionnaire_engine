# DateField
# - a question that provides a calendar/date picker

class DateField < Question
  
  def response(app=nil)
    retVal = ''
    if @answers.nil?
      #try to find answer from external object
      if !app.nil? and !object_name.blank? and !attribute_name.blank?
        retVal = eval("app." + object_name + "." + attribute_name) unless eval("app." + object_name + ".nil?")
      else 
        retVal = ''
      end
    else
      retVal = @answers[0].value
    end
    begin
      date = retVal == '' ? retVal : retVal
    rescue
      date = ''
    end
  end
  
  def validation_class
    if self.style == 'mmyy'
      'validate-selection' + super
    else
      'validate-date ' + super
    end
  end
  
  def response(app=nil)
    #return format_date_response(app)
    r = get_response(app).to_s
    return Time.parse(r) unless r.blank?    
  end
  
  def display_response(app=nil)
    return format_date_response(app)
  end
  
  def format_date_response(app=nil)
    r = get_response(app).to_s
    begin
      return Date.parse(r).strftime("%m/%d/%Y") unless r.blank?    
    rescue ArgumentError
      return ''
    end
  end
  
  # which view to render this element?
  def template
    if self.style == 'mmyy'
      'date_field_mmyy'
    else
      'date_field'
    end
  end
  
end

