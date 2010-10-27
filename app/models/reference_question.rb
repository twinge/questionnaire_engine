# ReferenceQuestion
# - a question that provides a fields to specify a reference

class ReferenceQuestion < Question
  
  def response(app=nil)
    return unless app
    ReferenceSheet.find_by_question_id_and_applicant_answer_sheet_id(id, app.id) || ReferenceSheet.create(:applicant_answer_sheet_id => app.id, :question_id => id) 
  end
  
  def has_response?(app)
    reference = response(app)
    reference && reference.valid?
  end
  
  def display_response(app=nil)
    return response(app).to_s
  end
  
  # which view to render this element?
  def ptemplate
    "reference_#{style}"
  end
  
end

