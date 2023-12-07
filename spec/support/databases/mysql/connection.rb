# frozen_string_literal: true

def connection
  ActiveRecord::Base.connection
end

# docker run --rm --name mysql-container --publish 3308:3306 --env MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:latest

def db_config
  {
    adapter: "mysql2",
    host: ENV["MYSQL_HOST"] || "0.0.0.0",
    port: ENV["MYSQL_PORT"] || 3308,
    username: ENV["MYSQL_USERNAME"] || "root",
    password: ENV.fetch("MYSQL_PASSWORD", nil),
    database: "uuid_v7_test"
  }
end

RSpec.configure do |config|
  config.before(:suite) do
    require "uuid_v7/types/mysql_type"
    ActiveRecord::Type.register(:uuid_v7, UuidV7::Types::MysqlType, adapter: :mysql2)

    # Create the database
    ActiveRecord::Base.establish_connection(db_config.except(:database))
    if connection.data_source_exists?(db_config[:database])
      connection.drop_database(db_config[:database]) # It happens if the test suite is killed after a breakpoint.
    else
      connection.create_database(db_config[:database], charset: "utf8mb4")
    end
    ActiveRecord::Base.establish_connection(db_config)

    # Load the schema
    load File.expand_path("../mysql/schema.rb", __dir__)

    # Load the data
    load File.expand_path("../../data.rb", __dir__)
  end

  config.after(:suite) do
    # Drop the database
    ActiveRecord::Base.establish_connection(db_config)
    connection.drop_database(db_config[:database])
  end
end
