# frozen_string_literal: true

require "uuid_v7"

UuidV7.configure do |config|
  config.field_name = :uuid
end

ENV["RAILS_ENV"] ||= "test"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

# Load support files
Dir["./spec/support/**/*.rb"].each do |file|
  next if /databases|data/.match?(file)

  puts("Loading #{file}")

  require file
end

# Load database support files
ENV["DATABASE"] ||= "sqlite3"
database = ENV.fetch("DATABASE", nil)
require "support/databases/#{database}/connection"

require "support/database_cleaner"
