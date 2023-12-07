# frozen_string_literal: true

require_relative "base"

module UuidV7
  module Types
    class SqliteType < Base
      # SQLite does not return binary data, it returns a String, no need to unpack it.
      def deserialize(value)
        return unless value

        cast(value)
      end
    end
  end
end
