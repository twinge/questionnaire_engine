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
    db_dir = gem_dir + "/test/dummy/db"
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
    desc "_clean :: rm the Qe refs in test/dummy/app/assets"
    task :clean_assets do
      puts "TODO regex delete the Qe engine refs"
    end


desc "install gem to test/dummy application "
task :ginstall do
  dummy_dir = File.dirname(__FILE__) + "/test/dummy"
  cmd = "cd " + dummy_dir + " && bundle exec rails generate qe:install"
  sh cmd
  puts ">> QE ran installer"
end


