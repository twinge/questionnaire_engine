# AttachmentField
# - a file upload question

class AttachmentField < Question
  
  # css class names for javascript-based validation
  def validation_class
    validation = ''
    validation += ' required' if self.required?
    validation
  end
  
end