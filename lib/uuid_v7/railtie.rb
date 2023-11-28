# frozen_string_literal: true

require "rails/railtie"
require "active_record"

module UuidV7
  class Railtie < Rails::Railtie
    initializer "uuid_v7.initialize" do
      ActiveSupport.on_load(:active_record) do
        include UuidV7 unless include?(UuidV7)
      end
    end
  end
end
