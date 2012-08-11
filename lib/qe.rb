require 'qe/engine'

module Qe
	# prefix for database tables
  mattr_accessor :table_name_prefix
  self.table_name_prefix ||= 'qe_'
  
  mattr_accessor :answer_sheet_class
  self.answer_sheet_class = 'AnswerSheet'
  
  mattr_accessor :from_email
  self.from_email = 'info@example.com'
end

require 'qe/model_extensions'

# ACTIVE SUPPORT CONCERN FILES

## controllers
require 'qe/concerns/controllers/admin/elements_controller'
require 'qe/concerns/controllers/admin/email_templates_controller'
require 'qe/concerns/controllers/admin/question_pages_controller'
require 'qe/concerns/controllers/admin/question_sheets_controller'
require 'qe/concerns/controllers/answer_pages_controller'
require 'qe/concerns/controllers/answer_sheets_controller'
require 'qe/concerns/controllers/application_controller'
require 'qe/concerns/controllers/reference_sheets_controller'

## models
require 'qe/concerns/models/element'
require 'qe/concerns/models/question'
Dir[File.dirname(__FILE__) + '/qe/concerns/models/*.rb'].each {|file| require file }

## presenters
require 'qe/concerns/presenters/presenter'
require 'qe/concerns/presenters/answer_pages_presenter'
