require "qe/engine"

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
require 'qe/concerns/models/answer_sheet_question_sheet.rb'
require 'qe/concerns/models/answer_sheet.rb'
require 'qe/concerns/models/answer.rb'
require 'qe/concerns/models/attachment_field.rb'
require 'qe/concerns/models/choice_field.rb'
require 'qe/concerns/models/condition.rb'
require 'qe/concerns/models/date_field.rb'
require 'qe/concerns/models/element.rb'
require 'qe/concerns/models/email_template.rb'
require 'qe/concerns/models/notifier.rb'
require 'qe/concerns/models/option_group.rb'
require 'qe/concerns/models/option.rb'
require 'qe/concerns/models/page_element.rb'
require 'qe/concerns/models/page_link.rb'
require 'qe/concerns/models/page.rb'
require 'qe/concerns/models/paragraph.rb'
require 'qe/concerns/models/question_grid_with_total.rb'
require 'qe/concerns/models/question_grid.rb'
require 'qe/concerns/models/question_set.rb'
require 'qe/concerns/models/question_sheet.rb'
require 'qe/concerns/models/question.rb'
require 'qe/concerns/models/reference_question.rb'
require 'qe/concerns/models/reference_sheet.rb'
require 'qe/concerns/models/section.rb'
require 'qe/concerns/models/state_chooser.rb'
require 'qe/concerns/modelstext_field.rb'

## presenters
require 'qe/concerns/presenters/presenter'
require 'qe/conerns/presenters/answer_pages_presenter'
