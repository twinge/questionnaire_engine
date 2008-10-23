# install files
['/public/questionnaire_engine', '/public/javascripts/questionnaire_engine', '/public/stylesheets/questionnaire_engine', '/public/images/questionnaire_engine'].each do |dir|
  source = File.join(File.dirname(__FILE__), dir)
  dest = RAILS_ROOT + dir
  FileUtils.mkdir_p(dest)
  FileUtils.cp(Dir.glob(source+'/**/*.*'), dest)
end