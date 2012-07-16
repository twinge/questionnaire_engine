require "qe/engine"

module Qe
	# prefix for database tables
  # mattr_accessor :table_name_prefix
  self.table_name_prefix ||= 'qe_'
  
  # mattr_accessor :answer_sheet_class
  # self.answer_sheet_class = 'AnswerSheet'
  
  # mattr_accessor :from_email
  # self.from_email = 'info@example.com'
end
