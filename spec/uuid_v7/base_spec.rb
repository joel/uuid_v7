# frozen_string_literal: true

module UuidV7
  class Bar < ActiveRecord::Base
  end

  RSpec.describe Base do
    def connection
      ActiveRecord::Base.connection
    end

    def db_config
      {
        adapter: "mysql2",
        host: ENV["MYSQL_HOST"] || "localhost",
        username: ENV["MYSQL_USERNAME"] || "root",
        password: ENV["MYSQL_PASSWORD"] || "supersecret",
        database: "binuuid_rails_test"
      }
    end

    before :all do # rubocop:disable RSpec/BeforeAfterAll
      Bar.include(described_class)

      db_config_without_db_name = db_config.dup
      db_config_without_db_name.delete(:database)

      # Create a connection without selecting a database first to create the db
      ActiveRecord::Base.establish_connection(db_config_without_db_name)
      connection.create_database(db_config[:database], charset: "utf8mb4")

      # Then establish a new connection with the database name
      ActiveRecord::Base.establish_connection(db_config)

      # Uncomment this line to get logging on stdout
      # ActiveRecord::Base.logger = Logger.new(STDOUT)

      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :bars do |t|
          t.binary :uuid, limit: 16, null: false, index: { unique: true }
          t.string :name
          t.timestamps
        end
      end
    end

    after :all do # rubocop:disable RSpec/BeforeAfterAll
      connection.drop_database(db_config[:database])
    end

    let(:uuid_v7_regex) { /\A\h{8}-\h{4}-7\h{3}-[89ab]\h{3}-\h{12}\z/ }
    let(:base58_uuid_regex) { /\A[1-9A-HJ-NP-Za-km-z]{21}\z/ }
    let(:int_uuid_regex) { /\A\d{37}\z/ }

    it "generates an uuid" do
      expect(Bar.new.uuid).to match(uuid_v7_regex)
    end

    it "doesn't override a UUID set in the initializer attributes" do
      override_uuid = SecureRandom.uuid_v7
      bar = Bar.new(uuid: override_uuid)
      expect(bar.uuid).to eql(override_uuid)
    end

    it "finds by base58 uuid" do
      bar = Bar.create

      expect(Bar.find_by_base58_uuid(bar.uuid_as_base58)).to eql(bar)
    end

    it "converts UUID to base58" do
      expect(Bar.new.uuid_as_base58).to match(base58_uuid_regex)
    end

    it "converts UUID to int" do
      expect(Bar.new.uuid_as_int.to_s).to match(int_uuid_regex)
    end
  end
end
