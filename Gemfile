source "http://rubygems.org"

gemspec

gem 'jquery-rails'

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
