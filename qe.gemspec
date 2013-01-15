$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qe"
  s.version     = Qe::VERSION
  s.authors     = ['josh starcher', 'weston platter']
  s.email       = ['josh@example.com', 'westonplatter@gmail.com']
  s.homepage    = 'https://github.com/twinge/questionnaire_engine'
  s.summary     = 'Rails Engine to handle question and answer functionality'
  s.description = 'Rails Engine with full MVC architecture to handle question and answer functionality in modulelized namespace'

  s.files = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 3.2.11'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
end
