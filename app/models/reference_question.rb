# ReferenceQuestion
# - a question that provides a fields to specify a reference

class ReferenceQuestion < Question
  
  def response(app=nil)
    return unless app
    # A reference is the same if the related_question_sheet corresponding to the question is the same
    reference = ReferenceSheet.find_by_applicant_answer_sheet_id_and_question_id(app.id, id)
    # if references.present?
    #   reference = references.detect {|r| r.question_id == id }
    #   # If they have another reference that matches this question id, don't go fishing for another one
    #   unless reference
    #     # If the question_id doesn't match, but the reference question is based on the same reference template (question sheet)
    #     # update the reference with the new question_id
    #     reference = references.detect {|r| r.question.related_question_sheet_id == related_question_sheet_id}
    #     reference.update_attribute(:question_id, id) if reference
    #   end
    # end
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

