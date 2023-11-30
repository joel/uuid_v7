# frozen_string_literal: true

require "active_record"

if ENV["DEBUG"]
  require "logger"
  ActiveRecord::Base.logger = Logger.new($stdout)
end
