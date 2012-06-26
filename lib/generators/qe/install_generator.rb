module Qe
	class InstallGenerator < Rails::Generators::Base

		class_option :migrate, :type => :boolean, :default => true, :banner => 'Run Questionnaire migrations'
    class_option :lib_name, :type => :string, :default => 'qe'
    class_option :quite, :type => :boolean, :default => false

    # def self.source_paths
    #   paths << File.expand_path('../templates', "../../#{__FILE__}")
    #   paths << File.expand_path('../templates', "../#{__FILE__}")
    #   paths << File.expand_path('../templates', __FILE__)
    #   paths.flatten
    # end

    def prepare_options
      @run_migrations = options[:migrate]
      @lib_name = options[:lib_name]
    end

    # def config_questionnaire_yml
    # end

    # def additional_tweaks
    # end

    def install_migrations
      say_status :copying, "migrations"
      silence_stream(STDOUT) do
        silence_warnings { rake 'qe:install:migrations' }
      end
    end

    def create_database
      say_status :creating, "database"
      silence_stream(STDOUT) do
        silence_stream(STDERR) do
          silence_warnings { rake 'db:create' }
        end
      end
    end

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
      :after => "pplication.routes.draw do\n" do
%Q{
  # == Questionnaire
  # This line mounts QuestionnaireEngine's routes at the root of your application.
  # This means, any requests to URLs such as http://localhost:3000/user, will go to 
  # Questionnaire::Elements. If you would like to change where this engine
  # is mounted, simply change the :at option to something different.
  #
  # DON'T TRUST THIS - We ask that you don't use the :as option here, as
  # Questionnaire relies on it being the default of "Qe"
  #
  mount Qe::Engine, :at => '/'
\n
} end
      unless options[:quiet]
        puts "*" * 75
        puts "We added the following line to your application's config/routes.rb file:"
        puts " "
        puts "    mount Qe::Engine, :at => '/'"
      end
    end


    def noify_about_javascripts
      insert_into_file File.join('app', 'assets', 'javascripts', 'application.js'), 
      :before => "//= require_tree ." do
        %Q{//= require qe/application \n} 
      end
      unless options[:quiet]
        puts "*" * 75
        puts "We added the following line tou your applications javascripts file,"
        puts " "
        puts "  //= require qe/application "
      end
    end


    def notify_about_stylesheets
      insert_into_file File.join('app', 'assets', 'stylesheets', 'application.css'), 
      :before => "*= require_tree ." do
          %Q{*= require qe/application \n }
      end 
      unless options[:quiet]
        puts "*" * 75
        puts "We added the following line tou your applications stylesheets file,"
        puts " "
        puts "  //= require qe/application "
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
        puts ">> Questionnaire has been installed successfully."
        puts ">> You're all ready to go!"
        puts " "
        puts ">> Enjoy!"
      end
    end

	end
end
