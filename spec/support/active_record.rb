# frozen_string_literal: true

require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

if ENV["DEBUG"]
  require "logger"
  ActiveRecord::Base.logger = Logger.new($stdout)
end
