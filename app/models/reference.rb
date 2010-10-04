# Reference
# - a question that provides a fields to specify a reference

class Reference < Question
  
  def response(app=nil)
    id = super
    id.present? ? Reference.find(id) : Reference.new
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
    "reference_#{style}"
  end
  
end

