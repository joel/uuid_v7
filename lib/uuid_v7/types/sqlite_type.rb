# frozen_string_literal: true

require_relative "base"

module UuidV7
  module Types
    class SqliteType < Base
      # In some configuration SQLite does not return binary data, it returns a String, in that case no need to unpack it.
      # However, in some other configurations, it returns binary data, in that case we need to unpack it. activemodel (8.0.0)
      # Note: If you are using SQLite3 >= 2.2, and Rails >= 8.0 you can get rid of this method all together.
      def deserialize(value)
        return unless value

        if value.is_a?(String) && value.encoding == Encoding::ASCII_8BIT && !value.match?(/\A\h{8}\h{4}\h{4}\h{4}\h{12}\z/)
          # The value is binary encoded; unpack it
          cast(value.unpack1("H*"))
        else
          # The value is a plain hex string; use it directly
          cast(value)
        end
      end
    end
  end
end
