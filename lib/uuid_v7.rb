# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/uuid_v7/railtie.rb")
loader.setup

require "uuid_v7/railtie" if defined?(Rails)

module UuidV7
  extend Configure
  class Error < StandardError; end
end
