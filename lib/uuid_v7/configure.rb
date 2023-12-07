# frozen_string_literal: true

module UuidV7
  module Configure
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
