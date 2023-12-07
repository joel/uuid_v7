# frozen_string_literal: true

require "rails/railtie"
require "active_support"

module UuidV7
  class Railtie < Rails::Railtie
    initializer "uuid_v7.initialize" do
      case ActiveRecord::Base.connection.adapter_name
      when "SQLite"
        require_relative "types/sqlite_type"
        ActiveRecord::Type.register(:uuid_v7, UuidV7::Types::SqliteType, adapter: :sqlite3)
      when "Mysql2"
        require_relative "types/mysql_type"
        ActiveRecord::Type.register(:uuid_v7, UuidV7::Types::MysqlType, adapter: :mysql2)

        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Migration.include(Patches::Mysql::FxMigration) unless ActiveRecord::Migration.include?(Patches::Mysql::FxMigration)
        end
      when "PostgreSQL"
        raise NotImplementedError, "PostgreSQL support native UUID type, no need for this gem."
      else
        raise NotImplementedError, "Adapter #{ActiveRecord::Base.connection.adapter_name} not supported"
      end

      Rails.application.config.after_initialize do
        if UuidV7.configuration.implicit_inclusion_strategy
          ActiveSupport.on_load(:active_record) do
            include UuidV7::Base unless include?(UuidV7::Base)
          end
        end
      end
    end
  end
end
