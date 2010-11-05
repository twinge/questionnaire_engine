# ReferenceQuestion
# - a question that provides a fields to specify a reference

class ReferenceQuestion < Question
  
  def response(app=nil)
    return unless app
    # A reference is the same if the related_question_sheet corresponding to the question is the same
    references = ReferenceSheet.find_all_by_applicant_answer_sheet_id(app.id)
    if references.present?
      reference = references.detect {|r| r.question_id == id }
      unless reference
        reference = references.detect {|r| r.question.related_question_sheet_id == related_question_sheet_id}
        reference.update_attribute(:question_id, id) if reference
      end
    end
    reference || ReferenceSheet.create(:applicant_answer_sheet_id => app.id, :question_id => id) 
  end
  
  def has_response?(app = nil)
    if app
      reference = response(app)
      reference && reference.valid?
    else
      ReferenceSheet.where(:question_id => id).count > 0
    end
  end
  
  def display_response(app=nil)
    return response(app).to_s
  end
  
  # which view to render this element?
  def ptemplate
    "reference_#{style}"
  end
  
end

