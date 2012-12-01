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

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require "rspec/core/rake_task" 

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  # spec.rspec_opts = ['-cfs --backtrace']
end

desc "runs simplecov report"
task :cov do
  # sh "COVERAGE=true rake"
  sh 'bundle exec rake spec COVERAGE=true'
end 

# ==============================================================================
# custom, non-standard development rake tasks

require 'thor/actions'

desc "run :: master action"
task :run => [:run_migrations] do end

  desc "_run :: drops, creates, migrates QE migrations"
  task :run_migrations do 
    sh "rake db:drop; rake db:create; rake db:migrate --trace"
  end


desc "clean :: master action"
task :clean => [:clean_drop_db, :clean_db_folder] do end

  desc "_clean :: drop db"
  task :clean_drop_db do 
    sh "rake db:drop;"
  end

  desc "_clean :: rm db/schema.rb and db/migrate/*"
  task :clean_db_folder do
    gem_dir = File.dirname(__FILE__)
    db_dir = gem_dir + "/spec/dummy/db"
    sh "rm -rf " + db_dir
    sh "mkdir " + db_dir
    sh "mkdir " + db_dir + "/migrate"
  end

    # TODO code this
    desc "_clean :: rm the Qe mounting in config/routes.rb"
    task :clean_routes do
      puts "TODO regex delete the Qe engine mounting"
    end

    # TODO code this
    desc "_clean :: rm the Qe refs in spec/dummy/app/assets"
    task :clean_assets do
      puts "TODO regex delete the Qe engine refs"
    end


desc "install gem to spec/dummy application "
task :ginstall do
  dummy_dir = File.dirname(__FILE__) + "/spec/dummy"
  cmd = "cd " + dummy_dir + " && bundle exec rails generate qe:install"
  sh cmd
  puts ">> QE ran installer"
end


