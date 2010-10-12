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

def recursive_copy(source, dest)
  Dir.glob(source + '/*').each do |file|
    case File.ftype(file)
    when 'directory'
      new_dest = dest.join(File.basename(file))
      Rails.logger.debug "Creating: #{new_dest}"
      FileUtils.mkdir_p(new_dest)
      recursive_copy(file, new_dest)
    else
      Rails.logger.debug "Copying: #{file}"
      FileUtils.cp(file, dest)
    end
  end
end

['public'].each do |dir|
  source = File.dirname(__FILE__) + "/#{dir}"
  dest = Rails.root + dir
  FileUtils.mkdir_p(dest)
  recursive_copy(source, dest)
end
