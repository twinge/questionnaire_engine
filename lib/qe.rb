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
require 'qe/concerns/models/answer_sheet_question_sheet'
require 'qe/concerns/models/answer_sheet'
require 'qe/concerns/models/answer'
require 'qe/concerns/models/attachment_field'
require 'qe/concerns/models/choice_field'
require 'qe/concerns/models/condition'
require 'qe/concerns/models/date_field'
require 'qe/concerns/models/element'
require 'qe/concerns/models/email_template'
require 'qe/concerns/models/notifier'
require 'qe/concerns/models/option_group'
require 'qe/concerns/models/option'
require 'qe/concerns/models/page_element'
require 'qe/concerns/models/page_link'
require 'qe/concerns/models/page'
require 'qe/concerns/models/paragraph'
require 'qe/concerns/models/question_grid_with_total'
require 'qe/concerns/models/question_grid'
require 'qe/concerns/models/question_set'
require 'qe/concerns/models/question_sheet'
require 'qe/concerns/models/question'
require 'qe/concerns/models/reference_question'
require 'qe/concerns/models/reference_sheet'
require 'qe/concerns/models/section'
require 'qe/concerns/models/state_chooser'
require 'qe/concerns/models/text_field'

## presenters
require 'qe/concerns/presenters/presenter'
require 'qe/concerns/presenters/answer_pages_presenter'
