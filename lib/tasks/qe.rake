def recursive_copy(source, dest)
  Dir.glob(source + '/*').each do |file|
    case File.ftype(file)
    when 'directory'
      new_dest = dest.join(File.basename(file))
      puts "Creating: #{new_dest}"
      FileUtils.mkdir_p(new_dest)
      recursive_copy(file, new_dest)
    else
      puts "Copying: #{file}"
      FileUtils.cp(file, dest)
    end
  end
end

namespace :qe do
  desc "Installs static files"
  task :copy_assets do
    puts "Copying assets..."
    source = File.join(File.dirname(__FILE__), '..', '..', "public")
    dest = Rails.root + 'vendor/assets'
    FileUtils.mkdir_p(dest)
    recursive_copy(source, dest)
    FileUtils.mv(Rails.root + 'vendor/assets/qe', Rails.root + 'public/qe')
  end
  
  desc "Copy migrations over"
  task :copy_migrations do
    puts "Copying migrations..."
    source = File.join(File.dirname(__FILE__), '..', '..', "db", 'migrate')
    dest = Rails.root.join('db','migrate')
    Dir.glob(source + '/*').each do |file|
      @skip = false
      parts = file.split('/').last.split('_')
      Dir.glob(dest.join('*').to_s).each do |existing|
        @skip = true if existing.to_s.include?(parts[1..-1].join('_'))
      end
      unless @skip
        dest_filename = dest.join([Time.now.utc.strftime("%Y%m%d%H%M%S"), parts[1..-1]].flatten.join('_'))
        puts "Copying: #{dest_filename}"
        FileUtils.cp(file, dest_filename)
        sleep(1)
      end
    end
  end
  
  desc "Install QE files"
  task :install do
    Rake::Task["qe:copy_assets"].invoke
    Rake::Task["qe:copy_migrations"].invoke
  end
end