module Qe
  class InstallGenerator < Rails::Generators::Base

    class_option :migrate, :type => :boolean, :default => false, :banner => 'Run Qe migrations?'
    class_option :lib_name, :type => :string, :default => 'qe'
    class_option :quite, :type => :boolean, :default => false

    def prepare_options
      @run_migrations = options[:migrate]
      @lib_name = options[:lib_name]
    end

    def install_migrations
      say_status :copying, "migrations"
      silence_stream(STDOUT) do
        silence_warnings { rake 'qe:install:migrations' }
      end
    end

    # @todo we should ask the developer if they want upvote to create the db.
    #
    # def create_database
    #   say_status :creating, "database"
    #   silence_stream(STDOUT) do
    #     silence_stream(STDERR) do
    #       silence_warnings { rake 'db:create' }
    #     end
    #   end
    # end

    def run_migrations
      if @run_migrations
        say_status :running, "migrations"
        quietly { rake 'db:migrate' }
      else
        say_status :skipping, "migrations (don't forget to run rake db:migrate)"
      end
    end

    def notify_about_routes
      insert_into_file File.join('config', 'routes.rb'),
      :after => "Application.routes.draw do\n" do
%Q{
  # == Qe
  # This line mounts Qe's routes at the root of your application.
  # This means, any requests to URLs such as
  # http://localhost:3000/qe/*, will be handled by Qe. If
  # you would like to change where this engine is mounted, simply change
  # the :at option to something different.
  #
  mount Qe::Engine, :at => 'qe/'
\n
} end
      unless options[:quiet]
        puts "*" * 75
        puts " We added the following line to your application's config/routes.rb file:"
        puts " "
        puts "    mount Qe::Engine, :at => 'qe/'"
        puts " "
      end
    end


    def noify_about_javascripts
      insert_into_file File.join('app', 'assets', 'javascripts', 'application.js'),
      :before => "//= require_tree ." do
        %Q{//= require qe/application \n}
      end
      unless options[:quiet]
        puts "*" * 75
        puts " Qe added the following line tou your applications javascripts file,"
        puts " "
        puts "  //= require qe/application"
        puts " "
      end
    end


    def notify_about_stylesheets
      insert_into_file File.join('app', 'assets', 'stylesheets', 'application.css'),
      :before => "*= require_tree ." do
          %Q{*= require qe/application \n }
      end
      unless options[:quiet]
        puts "*" * 75
        puts " Qe added the following line tou your applications stylesheets file,"
        puts " "
        puts "  //= require qe/application"
        puts " "
      end
    end

    # TODO figure out image refernces
    # def notify_about_images
    #   insert_into_file File.join('app', 'assets', 'images', 'application.css')
    # end

    def complete
      unless options[:quiet]
        puts "*" * 75
        puts " "
        puts ">> Qe has been installed successfully."
        puts ">> You're all ready to go!"
        puts " "
        puts ">> Build something awesome!"
      end
    end


  end
end
