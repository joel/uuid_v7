# frozen_string_literal: true

require "active_model/type"

module UuidV7
  module Types
    class InvalidUUID < StandardError; end

    class Base < ActiveModel::Type::Binary
      def type
        :uuid_v7
      end

      # Type casts a value from user input (e.g. from a setter). This value may
      # be a string from the form builder, or a ruby object passed to a setter.
      # There is currently no way to differentiate between which source it came
      # from.
      #
      # The return value of this method will be returned from
      # ActiveRecord::AttributeMethods::Read#read_attribute. See also:
      # Value#cast_value.
      #
      # +value+ The raw input, as provided to the attribute setter.
      def cast(value)
        return unless value

        super(add_dashes(value.to_s)) # super will encode the value as binary (Encoding::BINARY)
      end

      # Casts a value from the ruby type to a type that the database knows how
      # to understand. The returned value from this method should be a
      # +String+, +Numeric+, +Date+, +Time+, +Symbol+, +true+, +false+, or
      # +nil+.
      def serialize(value)
        return unless value

        # To avoid SQL injection, verify that it looks like a UUID. ActiveRecord
        # does not explicity escape the Binary data type. escaping is implicit as
        # the Binary data type always converts its value to a hex string.
        raise InvalidUUID, "#{value} is not a valid UUID" unless value.match?(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)

        return value if value.is_a?(Data)

        Data.new(strip_dashes(value))
      end

      # Converts a value from database input to the appropriate ruby type. The
      # return value of this method will be returned from
      # ActiveRecord::AttributeMethods::Read#read_attribute. The default
      # implementation just calls Value#cast.
      #
      # +value+ The raw input, as provided from the database.

      # ActiveModel::Type::Binary implements this method as:
      # def deserialize(value)
      #   cast(value)
      # end
      def deserialize(value)
        return unless value

        # If the value is a binary data, convert it to a hex string, and call cast(value)
        if value.is_a?(String) && value.encoding == Encoding::ASCII_8BIT
          super(value.unpack1("H*"))
        else
          super # foward to cast(value)
        end
      end

      # We need to override the hex method to avoid unpacking when quoting
      # ActiveRecord calls hex method when quoting a value.
      # https://github.com/rails/rails/blob/7-1-stable/activerecord/lib/active_record/connection_adapters/mysql/quoting.rb#L57
      class Data < ActiveModel::Type::Binary::Data
        def initialize(value)
          @value = value

          super(value)
        end

        def hex
          @value
        end
      end

      private

      # A UUID consists of 5 groups of characters.
      #   8 chars - 4 chars - 4 chars - 4 chars - 12 characters
      #
      # This function re-introduces the dashes since we removed them during
      # serialization, so:
      #
      #   add_dashes("2b4a233152694c6e9d1e098804ab812b")
      #     => "2b4a2331-5269-4c6e-9d1e-098804ab812b"
      #
      def add_dashes(uuid)
        return uuid if uuid.include?("-")

        [uuid[0..7], uuid[8..11], uuid[12..15], uuid[16..19], uuid[20..]].join("-")
      end

      # A UUID has 4 dashes is displayed with 4 dashes at the same place all
      # the time. So they don't add anything semantically. We can safely remove
      # them before storing to the database, and re-add them whenever we
      # retrieved a value from the database.
      #
      #   strip_dashes("2b4a2331-5269-4c6e-9d1e-098804ab812b")
      #     => "2b4a233152694c6e9d1e098804ab812b"
      #
      def strip_dashes(uuid)
        uuid.delete("-")
      end
    end
  end
end
