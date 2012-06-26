#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Questionnaire'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end



# ==============================================================================
# custom, non-standard rake tasks

require 'thor/actions'

task :data do 
  sh "rake db:drop; rake db:create; rake db:migrate --trace"
end

task :rm do
  gem_dir = File.dirname(__FILE__)
  db_dir = gem_dir + "/test/dummy/db"
  sh "rm -rf " + db_dir
  sh "mkdir " + db_dir
  sh "mkdir " + db_dir + "/migrate"
end

task :kin do
  gem_dir = File.dirname(__FILE__)
  dummy_dir = gem_dir + "test/dummy"
  sh dummy_dir.to_s + " rails generate qe:install"
  sh "echo \">> QE ran installer\""
end

# task :default => :app_rake_db_ops
# task :default => :app_install_remove_files
