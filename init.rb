# Include hook code here

# You can't use config.load_paths because #set_autoload_paths has already been called in the Rails Initialization process
# http://weblog.techno-weenie.net/2007/1/24/understanding-the-rails-initialization-process

#models_path = File.join(directory, 'app', 'models', 'elements')

elements_path = "#{directory}/app/models"
transient_path = "#{directory}/app/models"
presenters_path = "#{directory}/app/presenters"

$LOAD_PATH << elements_path << transient_path << presenters_path
Dependencies.load_paths << elements_path << transient_path << presenters_path
# Rails.plugin[:questionnaire_engine].code_paths <<  presenters_path

