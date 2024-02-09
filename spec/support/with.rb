# frozen_string_literal: true

module With
  def with(**attributes)
    old_values = {}
    begin
      attributes.each do |key, value|
        old_values[key] = UuidV7.configuration.public_send(key)
        UuidV7.configuration.public_send(:"#{key}=", value)
      end
      yield self
    ensure
      old_values.each do |key, old_value|
        UuidV7.configuration.public_send(:"#{key}=", old_value)
      end
    end
  end
end

UuidV7.extend(With)
