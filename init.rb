# Include hook code here

# You can't use config.load_paths because #set_autoload_paths has already been called in the Rails Initialization process
# http://weblog.techno-weenie.net/2007/1/24/understanding-the-rails-initialization-process

#models_path = File.join(directory, 'app', 'models', 'elements')

# elements_path = "#{directory}/app/models"
# transient_path = "#{directory}/app/models"
# presenters_path = "#{directory}/app/presenters"

# $LOAD_PATH << presenters_path
Dir.glob(File.join(File.dirname(__FILE__) , 'app', 'helpers', '**')).each do |file|
  require file
end

Dir.glob(File.join(File.dirname(__FILE__) , 'app', 'presenters', '**')).each do |file|
  require file
end