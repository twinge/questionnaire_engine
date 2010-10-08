# Questionnaire
require 'questionnaire/engine' if defined?(Rails)

module Questionnaire
  # prefix for database tables
  mattr_accessor :table_name_prefix
  self.table_name_prefix ||= ''
end