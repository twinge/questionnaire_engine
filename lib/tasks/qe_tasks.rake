# desc "Explaining what the task does"
# task :questionnaire do
#   # Task goes here
# end

# from the old vendor plugin

	# def recursive_copy(source, dest)
	#   Dir.glob(source + '/*').each do |file|
	#     case File.ftype(file)
	#     when 'directory'
	#       new_dest = dest.join(File.basename(file))
	#       puts "Creating: #{new_dest}"
	#       FileUtils.mkdir_p(new_dest)
	#       recursive_copy(file, new_dest)
	#     else
	#       puts "Copying: #{file}"
	#       FileUtils.cp(file, dest)
	#     end
	#   end
	# end

	# namespace :qe do
	#   desc "Installs static files for the message_block gem"
	#   task :install do
	#     puts "Copying assets..."
	#     source = File.join(File.dirname(__FILE__), '..', '..', "public")
	#     dest = Rails.root + 'public'
	#     FileUtils.mkdir_p(dest)
	#     recursive_copy(source, dest)
	#   end
	# end