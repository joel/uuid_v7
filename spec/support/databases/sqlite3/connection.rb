# frozen_string_literal: true

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

RSpec.configure do |config|
  config.before(:suite) do
    require "uuid_v7/types/sqlite_type"
    ActiveRecord::Type.register(:uuid_v7, UuidV7::Types::SqliteType, adapter: :sqlite3)

    # Load the schema
    load File.expand_path("../sqlite3/schema.rb", __dir__)

    # Load the data
    load File.expand_path("../../data.rb", __dir__)
  end
end
