# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

ENV["DATABASE"] ||= "sqlite3"

case ENV.fetch("DATABASE", nil)
when "mysql"
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.exclude_pattern = "spec/integrations/migrations/sqlite3/*_spec.rb"
  end
when "sqlite3"
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.exclude_pattern = "spec/integrations/migrations/mysql/*_spec.rb"
  end
else
  raise "Unsupported database: #{ENV.fetch("DATABASE", nil)}"
end

require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["-A"] # auto_correct
end

task default: %i[spec rubocop]
