# predefined data sets for Questionnaire application

module QuestionnaireFixture
  # question sheet requires a label under 60 characters long
  def valid_question_sheet
    { :label => 'reference form' }
  end
  
  def valid_page(sheet)
    { 
      :label => 'page one',
      :number => 1,
      :question_sheet => sheet
    }
  end
  
  def valid_question(sheet, page)
    {
      :question_sheet => sheet,
      :page => page,
      :style => 'radio',
      :label => 'Do you like filling out forms?',
      :required => false,
      :slug => 'fill_forms',
      :position => 1
    }
  end
  
end

