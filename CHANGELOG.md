## [Unreleased]

## [0.1.3] - 2024-07-10

- Fix Zeitwerk::NameError
- Check if created_at is present

## [0.1.2] - 2024-02-09

Configure The Behaviours When UUID Is Invalid

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

## [0.1.1] - 2023-12-11

Fix wrong default field name. Change from :uuid to :id

## [0.1.0] - 2023-11-28

- Initial release
