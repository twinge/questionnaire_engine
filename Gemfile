source "http://rubygems.org"

gemspec
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'ckeditor', '3.7.1'
gem 'dynamic_form'

# for cru specific dev, pull in common_engine by:
#   git submodule init
#   git submodule update

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

gem 'rails-dummy', :github => 'westonplatter/rails-dummy'

gem 'database_cleaner', "~> 1.1.1", :git => 'https://github.com/tommeier/database_cleaner', ref: 'b0c666e'
