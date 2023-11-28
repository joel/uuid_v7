# frozen_string_literal: true

require "base58"

module UuidV7
  class Convertor
    class << self
      def to_base58(uuid)
        raise ArgumentError, "Invalid UUID" unless uuid.match?(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)

        uuid_to_int = uuid.delete("-").to_i(16)

        Base58.int_to_base58(uuid_to_int)
      end

      def to_int(base58)
        raise ArgumentError, "Invalid Base58" unless base58.match?(/\A\w{21}\z/)

        Base58.base58_to_int(base58)
      end
    end
  end
end
