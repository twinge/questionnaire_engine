# Questionnaire

module Questionnaire
  # prefix for database tables
  mattr_accessor :table_name_prefix
  self.table_name_prefix = ''
  
  mattr_accessor :answer_sheet_has_one
  self.answer_sheet_has_one = nil
end