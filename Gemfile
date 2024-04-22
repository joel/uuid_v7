# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in uuid_v7.gemspec
gemspec

gem "rake"
gem "rspec"
gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"

database = ENV["DATABASE"] || "sqlite3"
case database
when "sqlite3"
  gem "sqlite3", "~> 2.0"
when "mysql"
  gem "mysql2", "~> 0.5.5"
else
  raise "Unsupported database: #{database}"
end

gem "database_cleaner-active_record"
