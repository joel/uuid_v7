# UUID V7 for Ruby on Rails

## Introduction
`uuid_v7` is a RubyGem specifically designed to provide UUID V7 support for Mysql and Sqlite databases in Ruby on Rails applications. This gem is particularly useful because these databases lack a native type for supporting UUIDs.

**Note:** PostgreSQL users do not require this gem as PostgreSQL supports UUID natively.

## Supported databases

Mysql and SQLite

NOTE: Postgresql support natively UUID

## Features
- Converts UUID V7 CHAR(36) to a more efficient CHAR(32) and stores it in BINARY(16) for performance enhancement.
- Integrates seamlessly with `ActiveRecord::Base`, enabling UUID as the primary key for models.
- Migration helper for easy transition to UUIDs in existing Rails applications, specifically tailored for Mysql.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uuid_v7'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install uuid_v7
```

## Usage

### Basic Setup

Once installed, `uuid_v7` extends `ActiveRecord::Base` to use UUID as the primary key.

### Foreign Keys

Declare foreign key associations in your models as follows:

```ruby
class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  attribute :author_id, :uuid_v7
  belongs_to :author
end
```

## Configuration

### Custom Primary Key

If your primary key is not `:id`, run:

```bash
rails generate uuid_v7:install
```

And configure:

```ruby
UuidV7.configure do |config|
  config.field_name = :uuid
end
```

### Implicit Inclusion Strategy

By defaut the primary key type is overrided, if you want to prevent that behaviour toogle the strategy.

in `config/initializers/uuid_v7.rb``

```ruby
UuidV7.configure do |config|
  config.implicit_inclusion_strategy = false
end
```

Then add manually to the model you want.

```ruby
class Author < ActiveRecord::Base
  attribute :id, :uuid_v7, default: -> { SecureRandom.uuid_v7 }

  has_many :books
end
```

**Recommendation:** It's advised to use `:id` as the primary key with Rails for compatibility and convention.

### Behaviours with Invalid UUIDs

```ruby
UuidV7.configure do |config|
  config.throw_invalid_uuid = false
end
```

```ruby
record_class.find_by(uuid: "invalid")
=> nil
```

```ruby
UuidV7.configure do |config|
  config.throw_invalid_uuid = true
end
```

```ruby
record_class.find_by(uuid: "invalid")
raise_error(UuidV7::Types::InvalidUUID, "invalid is not a valid UUID")
```

### Migrations

#### Helper for Mysql

`uuid_v7` provides a migration helper for Mysql. To add a UUID field to a model, run:

```bash
rails generate migration AddUuidToUser uuid:binary
```

Then use the helper in your migration file:

```ruby
class AddUuidToUser < ActiveRecord::Migration[7.1]
  def change
    # Add the field :uuid
    populate_uuid_field(table_name: :users, column_name: :uuid)
  end
end
```

#### Custom Migration Template

To override the default `:id` implementation in new migrations:

```bash
rails generate uuid_v7:migrations
```

A modified migration template will be available under `lib/templates/active_record/migration/create_table_migration.rb`.

Example of a generated model migration:

```ruby
class AddAuthor < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: false do |t|
      t.binary :id, limit: 16, null: false, index: { unique: true }, primary_key: true
      t.string :name
      t.timestamps
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/joel/uuid_v7].

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `DEBUG=true bundle exec rake`, this run the code against SQLite.

For Mysql, please setup the database as follow:

```shell
docker run --rm \
  --name mysql-uuid-v7-test \
  --publish 3308:3306 \
  --env MYSQL_ALLOW_EMPTY_PASSWORD=yes \
  --detach mysql:latest
```

Create the databse:

```shell
docker exec mysql-uuid-v7-test bash -c "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS uuid_v7_test;'"
```

and run

`DEBUG=true MYSQL_HOST="0.0.0.0" MYSQL_PORT=3308 DATABASE=mysql bundle exec rake`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joel/uuid_v7. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joel/uuid_v7/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UuidV7 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joel/uuid_v7/blob/main/CODE_OF_CONDUCT.md).
