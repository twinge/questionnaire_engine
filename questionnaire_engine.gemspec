$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "questionnaire_engine"
  s.version     = Qe::VERSION
  s.authors     = ["Josh Starcher"]
  s.homepage    = "http://www.github.com/twinge/questionnaire_engine"
  s.summary     = "Rails engine that includes the logic to create surveys/questionnaires in your apps"
  s.description = "Rails engine that includes the logic to create surveys/questionnaires in your apps"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*", "spec/**/*"]

  s.add_dependency 'rails', '~> 3.2.6'
  s.add_dependency 'ckeditor', '3.7.1'
  s.add_dependency 'sass-rails'
  s.add_dependency 'dynamic_form'
  s.add_dependency 'state_machine'
  s.add_dependency 'aasm'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'paperclip'

  s.add_development_dependency 'mysql2', '~> 0.3.11'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'factory_girl_rails'
  
  # https://github.com/bmabey/database_cleaner/issues/224
  # https://github.com/bmabey/database_cleaner/pull/241
  # s.add_development_dependency 'database_cleaner', '1.0.1'
  
  # s.add_development_dependency 'rails-dummy'
end
