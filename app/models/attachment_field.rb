# AttachmentField
# - a file upload question

class AttachmentField < Question
  
  # which view to render this element?
  def template
    'attachment_field'
  end
  
  # css class names for javascript-based validation
  def validation_class
    validation = ''
    validation += ' required' if self.required?
    validation
  end
  
end