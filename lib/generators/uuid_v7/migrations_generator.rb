# frozen_string_literal: true

module UuidV7
  module Generators
    class MigrationsGenerator < Rails::Generators::Base
      source_root File.expand_path("migrations/templates", __dir__)

      desc "rails generate uuid_v7:migrations"
      def copy_initializer_file
        copy_file "create_table_migration.rb.tt", "lib/templates/active_record/migration/create_table_migration.rb.tt"
      end
    end
  end
end
