source "http://rubygems.org"

gemspec

gem 'jquery-rails' # jquery-rails is used by the dummy application
gem 'ckeditor', '3.7.1'
gem 'dynamic_form'
gem 'state_machine'

# gems needed for common_engine
# see gitmodules, IE
##   git submodule init
##   git submodule update
gem 'paperclip'

group :development, :test do
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'jruby-openssl'
  end

  platforms :mri do
    gem 'sqlite3'
    gem 'mysql2'
    gem 'pg'
  end
end

