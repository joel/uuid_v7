# frozen_string_literal: true

module UuidV7
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("install/templates", __dir__)

      desc "rails generate uuid_v7:install"
      def copy_initializer_file
        template "uuid_v7.rb.tt", "config/initializers/uuid_v7.rb"
      end
    end
  end
end
