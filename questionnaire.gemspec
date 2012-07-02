$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "questionnaire"
  s.version     = Qe::VERSION
  s.authors     = ["Josh Starcher", "Weston Platter"]
  s.email       = ["j@some-email.com", "westonplatter@gmail.com"]
  s.homepage    = "http://www.google.com"
  s.summary     = "Summary of Questionnaire."
  s.description = "Description of Questionnaire."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '3.2.6'
  s.add_dependency 'ckeditor', '3.7.1'
  s.add_dependency 'sass'
  s.add_dependency 'sass-rails'
  s.add_dependency 'dynamic_form'
  s.add_dependency 'state_machine'

  s.add_development_dependency 'mysql2', '~> 0.3.11'
  s.add_development_dependency 'ckeditor', '3.7.1'
  s.add_development_dependency 'rails',  '3.2.6'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'dynamic_form'
  s.add_development_dependency 'state_machine'
end
