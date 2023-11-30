# frozen_string_literal: true

require "base58"

module UuidV7
  class Converter
    UUID_REGEX = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
    UUID_SPLIT_REGEX = /\A(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})\z/
    UUID_V7_REGEX = /\A\h{8}-\h{4}-7\h{3}-[89ab]\h{3}-\h{12}\z/
    BASE58_UUID_REGEX = /\A[1-9A-HJ-NP-Za-km-z]{21}\z/
    INT_UUID_REGEX = /\A\d{37}\z/

    class << self
      def int_to_uuid(int)
        raise ArgumentError, "Invalid Integer" unless int.is_a?(Integer)

        # See https://gist.github.com/awesome/8760331 for more options for converting int to uuid
        int.to_s(16).rjust(32, "0").match(UUID_SPLIT_REGEX).to_a[1..].join("-")
      end

      def uuid_to_int(uuid)
        raise ArgumentError, "Invalid UUID" unless uuid.match?(UUID_REGEX)

        uuid.delete("-").to_i(16)
      end

      def base58_to_uuid(base58_val)
        raise ArgumentError, "Invalid Base58" unless base58_val.match?(BASE58_UUID_REGEX)

        int_to_uuid(Base58.base58_to_int(base58_val))
      end

      def uuid_to_base58(uuid)
        raise ArgumentError, "Invalid UUID" unless uuid.match?(UUID_REGEX)

        Base58.int_to_base58(uuid_to_int(uuid))
      end
    end
  end
end
